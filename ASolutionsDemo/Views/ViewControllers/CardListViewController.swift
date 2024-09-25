//
//  CardListViewController.swift
//  ASolutionsDemo
//
//  Created by Farid Rzayev on 25.09.24.
//


import UIKit

final class CardListViewController: UIViewController {
    
    public var viewModel: CardListViewModel!

    private lazy var tableView: UITableView = .build {
        $0.delegate = self
        $0.dataSource = self
        $0.register(cellType: CardListItemTableViewCell.self)
    }
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return control
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Card list"
        self.navigationItem.setHidesBackButton(true, animated: true)
        view.backgroundColor = .white
        tableView.refreshControl = refreshControl
        view.addSubviewSnp(tableView, insets: .init(top: 0, left: 16, bottom: 0, right: 16))
        addRightBarButtonItem()
        
        setupViewModel()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateList), name: .reloadCardList, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .reloadCardList, object: nil)
    }
    
    // MARK: - Setup Methods
    
    private func setupViewModel() {
        viewModel = CardListViewModel()
        bindViewModel()
        viewModel.fetchData()
    }
    
    private func bindViewModel() {
        viewModel.onCardListUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.onError = { errorMessage in
            DispatchQueue.main.async {
                errorMessage.show(.warning)
            }
        }
        
        viewModel.onSuccess = { successMessage in
            DispatchQueue.main.async {
                successMessage.show(.success)
            }
        }
    }
}

// MARK: - Private Methods

private extension CardListViewController {
    
    func addRightBarButtonItem() {
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapRightButton))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc
    private func refreshData() {
        viewModel.fetchData()
        refreshControl.endRefreshing()
    }
    
    @objc
    func didTapRightButton() {
        let alertModel = AlertModel(
            title: "Card details",
            subtitle: "Please enter your card 16 digits numbers",
            placeholder: .empty,
            buttonTitle: "Add card"
        ) { [weak self] inputText in
            self?.viewModel.addDebitCard(inputText ?? .empty)
        }
        AlertHelper.shared.createAlertWithTextField(with: alertModel, sender: self)
    }
    
    func redirectTransferScreen(debitCard: DebitCard) {
        let vc = TransferViewController(inputData: TransferInputData(debitCard: debitCard))
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    func updateList() {
        viewModel.fetchData()
    }
}

extension CardListViewController {
    func presentDeletionReasonActionSheet(forRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Select Reason", message: "Please select a reason for deleting the card.", preferredStyle: .actionSheet)
        
        // Add an action for each deletion reason
        for reason in DeletionReason.allCases {
            let action = UIAlertAction(title: reason.description, style: .default) { [weak self] _ in
                if reason == .other {
                    self?.presentOtherReasonAlert(at: indexPath)
                } else {
                    self?.handleCardDeletion(at: indexPath, reason: reason)
                }
            }
            alertController.addAction(action)
        }
        
        // Add a cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        // For iPad support (action sheets need a source view)
        if let popoverController = alertController.popoverPresentationController {
            if let cell = tableView.cellForRow(at: indexPath) {
                popoverController.sourceView = cell
                popoverController.sourceRect = cell.bounds
            } else {
                popoverController.sourceView = view
                popoverController.sourceRect = view.bounds
            }
        }
        
        present(alertController, animated: true)
    }
    
    private func handleCardDeletion(at indexPath: IndexPath, reason: DeletionReason? = nil, customReason: String? = nil) {
        if let customReason = customReason {
            print("Card deleted for custom reason: \(customReason)")
            // Proceed to delete the card
            viewModel.removeDebitCard(at: indexPath.row)
        } else if let reason = reason {
            print("Card deleted for reason: \(reason.description)")
            // Proceed to delete the card
            viewModel.removeDebitCard(at: indexPath.row)
        }
    }
    
    private func presentOtherReasonAlert(at indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Other Reason", message: "Please specify the reason for deleting the card.", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Enter reason here"
        }
        let confirmAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self, weak alertController] _ in
            if let reasonText = alertController?.textFields?.first?.text, !reasonText.isEmpty {
                // Handle deletion with custom reason
                self?.handleCardDeletion(at: indexPath, customReason: reasonText)
            } else {
                // User didn't enter a reason, you can choose to proceed or not
                "Please enter a reason.".show(.warning)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}

// MARK: - CardListItemCellDelegate

extension CardListViewController: CardListItemCellDelegate {
    func didTapTransferButton(on cell: CardListItemTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let cardViewModel = viewModel.getCardListItemViewModel(at: indexPath.row)
            let debitCard = cardViewModel.debitCard

            // Check if there are receiver cards available
            let receiverCards = viewModel.getReceiverCardsExcluding(cardNumber: debitCard.cardNumber)

            if receiverCards.isEmpty {
                // Show an alert or message to the user
                "No other cards available to transfer to.".show(.warning)
            } else {
                // Proceed to the transfer screen
                redirectTransferScreen(debitCard: debitCard)
            }
        }
    }
}
