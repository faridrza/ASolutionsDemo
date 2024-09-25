//
//  TransferViewController.swift
//  ASolutionsDemo
//
//  Created by Farid Rzayev on 25.09.24.
//


import UIKit

class TransferViewController: UIViewController {

    // MARK: - Properties

    private var viewModel: TransferViewModel!

    // MARK: - Views

    private lazy var scrollView: UIScrollView = .build {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }

    private lazy var receiverPicker: UIPickerView = .build {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = AppColors.background
    }

    // Add the toolbar
    private lazy var pickerToolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        // Create the Done button
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(didTapPickerDone)
        )

        // Add a flexible space to align the Done button to the right
        let flexibleSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )

        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        return toolbar
    }()

    private lazy var stackView: UIStackView = .build {
        $0.spacing = 8
        $0.axis = .vertical
    }

    private lazy var senderField: LabelInputTextField = .build {
        $0.configure(.init(title: "Sender", placeholder: .empty))
        $0.inputTextField.isEnabled = false
    }

    private lazy var senderBalanceField: LabelInputTextField = .build {
        $0.configure(.init(title: "Balance", placeholder: .empty))
        $0.inputTextField.isEnabled = false
    }

    private lazy var receiverField: LabelInputTextField = .build {
        $0.configure(.init(title: "Receiver", placeholder: "Please choose receiver card"))
        $0.inputTextField.inputView = receiverPicker
        $0.inputTextField.inputAccessoryView = pickerToolbar // Set the toolbar here
    }

    private lazy var receiverAmount: LabelInputTextField = .build {
        $0.configure(.init(title: "Amount", placeholder: "Please enter amount"))
        $0.inputTextField.keyboardType = .decimalPad
        $0.inputTextField.delegate = self
    }

    private lazy var transferButton: BaseButton = .build {
        $0.setTitle("Transfer", for: .normal)
        $0.addTarget(self, action: #selector(didTapTransferButton), for: .touchUpInside)
    }

    // MARK: - Initializer

    init(inputData: TransferInputData) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = TransferViewModel(senderDebitCard: inputData.debitCard)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Transfer between my cards"
        view.backgroundColor = .white

        setupUI()
        setupBindings()
        viewModel.fetchReceiverCards()

        hideKeyboardWhenTappedAround()
    }

    // MARK: - Private Methods

    private func setupBindings() {
        viewModel.onReceiverCardsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.receiverPicker.reloadAllComponents()
            }
        }

        viewModel.onTransferSuccess = { [weak self] in
            DispatchQueue.main.async {
                "Your transfer has been successful".show(.success)
                NotificationCenter.default.post(name: .reloadCardList, object: nil)
                self?.navigationController?.popViewController(animated: true)
            }
        }

        viewModel.onTransferError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                errorMessage.show(.error)
            }
        }

        viewModel.onValidationError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                errorMessage.show(.warning)
            }
        }
    }

    private func setupUI() {
        senderField.inputTextField.text = viewModel.senderDebitCard.cardNumber
        senderBalanceField.inputTextField.text = "\(viewModel.senderDebitCard.balance) AZN"

        addSubviews()
    }

    private func addSubviews() {
        view.addSubviewSnp(scrollView, insets: .init(top: 0, left: 16, bottom: 0, right: 16))
        scrollView.addSubviewSnp(stackView)

        stackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }

        transferButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }

        [
            senderField,
            senderBalanceField,
            receiverField,
            receiverAmount,
            transferButton
        ].forEach(stackView.addArrangedSubview)
    }

    @objc
    func didTapTransferButton() {
        UIView.animate(withDuration: 0.1,
                       animations: {
            self.transferButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        },
                       completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.transferButton.transform = CGAffineTransform.identity
            }
            self.view.endEditing(true)
            self.viewModel.startTransfer()
        })
    }

    // Add the Done button action
    @objc
    private func didTapPickerDone() {
        // Get the selected row
        let selectedRow = receiverPicker.selectedRow(inComponent: 0)
        if selectedRow >= 0 {
            // Update the text field and view model
            viewModel.selectReceiverCard(at: selectedRow)
            receiverField.inputTextField.text = viewModel.receiverCardTitle(at: selectedRow)
        }
        // Dismiss the picker view
        receiverField.inputTextField.resignFirstResponder()
    }
}
// MARK: - UITextFieldDelegate

extension TransferViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == receiverAmount.inputTextField {
            let currentText = textField.text ?? .empty
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

            // Regular expression to allow numbers with up to two decimal places
            let regex = "^[0-9]*((\\.|,)[0-9]{0,2})?$"
            let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
            let isValid = predicate.evaluate(with: updatedText)

            return isValid
        }

        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == receiverAmount.inputTextField {
            if let amountText = textField.text?.replacingOccurrences(of: ",", with: "."), let amount = Double(amountText) {
                viewModel.transferAmount = Double(round(100 * amount) / 100)
            } else {
                viewModel.transferAmount = 0.0
            }
        }
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension TransferViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.numberOfReceiverCards()
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.receiverCardTitle(at: row)
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // If you prefer to update selection immediately, uncomment the following lines
        // viewModel.selectReceiverCard(at: row)
        // receiverField.inputTextField.text = viewModel.receiverCardTitle(at: row)
    }
}
