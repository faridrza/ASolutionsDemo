//
//  TransferViewModel.swift
//  ASolutionsDemo
//
//  Created by Farid Rzayev on 25.09.24.
//


import Foundation

struct TransferInputData {
    let debitCard: DebitCard
}

class TransferViewModel {

    // MARK: - Input Properties

    let senderDebitCard: DebitCard
    private var debitCardHelper: DebitCardHelper

    // Receiver cards excluding the sender's card
    private(set) var receiverCards: [DebitCard] = [] {
        didSet {
            onReceiverCardsUpdated?()
        }
    }

    // Selected receiver card index
    private var selectedReceiverIndex: Int? {
        didSet {
            if let index = selectedReceiverIndex {
                selectedReceiverCard = receiverCards[index]
            } else {
                selectedReceiverCard = nil
            }
        }
    }

    private(set) var selectedReceiverCard: DebitCard?

    // Transfer amount
    var transferAmount: Double = 0.0 {
        didSet {
            // Round to two decimal places
            transferAmount = Double(round(100 * transferAmount) / 100)
            validateTransferAmount()
        }
    }

    // MARK: - Output Callbacks

    var onReceiverCardsUpdated: (() -> Void)?
    var onTransferSuccess: (() -> Void)?
    var onTransferError: ((String) -> Void)?
    var onValidationError: ((String) -> Void)?

    // MARK: - Initializer

    init(senderDebitCard: DebitCard, debitCardHelper: DebitCardHelper = DebitCardHelper.shared) {
        self.senderDebitCard = senderDebitCard
        self.debitCardHelper = debitCardHelper
    }

    // MARK: - Methods

    func fetchReceiverCards() {
        receiverCards = debitCardHelper.debitCards.filter { $0.cardNumber != senderDebitCard.cardNumber }
    }

    func numberOfReceiverCards() -> Int {
        return receiverCards.count
    }

    func receiverCardTitle(at index: Int) -> String {
        return receiverCards[index].cardNumber
    }

    func selectReceiverCard(at index: Int) {
        selectedReceiverIndex = index
    }

    func startTransfer() {
        guard let receiverCard = selectedReceiverCard else {
            onValidationError?("Please select a receiver card.")
            return
        }

        if transferAmount <= 0 {
            onValidationError?("Please enter a valid amount.")
            return
        }

        let result = debitCardHelper.startTransaction(sender: senderDebitCard, receiverCardNumber: receiverCard.cardNumber, amount: transferAmount)

        switch result {
        case .success:
            onTransferSuccess?()
        case .receiverNotFounded:
            onTransferError?("Receiver not found.")
        case .senderAmountInsufficient:
            onTransferError?("Insufficient funds.")
        }
    }

    // MARK: - Private Methods

    private func validateTransferAmount() {
        if transferAmount <= 0 {
            onValidationError?("Amount must be greater than zero.")
        }
    }
}
