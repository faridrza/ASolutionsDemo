//
//  CardListViewModel.swift
//  ASolutionsDemo
//
//  Created by Farid Rzayev on 25.09.24.
//


import Foundation

class CardListViewModel {

    // MARK: - Properties

    private var debitCardHelper: DebitCardHelper
    private(set) var cardList: [CardListItemViewModel] = [] {
        didSet {
            onCardListUpdated?()
        }
    }
    
    // Callbacks to notify the ViewController
    var onCardListUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    var onSuccess: ((String) -> Void)?

    // MARK: - Initializer

    init(debitCardHelper: DebitCardHelper = DebitCardHelper.shared) {
        self.debitCardHelper = debitCardHelper
    }

    // MARK: - Methods

    func fetchData() {
        cardList = debitCardHelper.debitCards.map { debitCard in
            CardListItemViewModel(debitCard: debitCard)
        }
    }

    func addDebitCard(_ cardNumber: String) {
        // Validation for length and digits
        let trimmedCardNumber = cardNumber.removeWhiteSpaces()
        let nonDigitsCharacterSet = CharacterSet.decimalDigits.inverted
        let containsNonDigits = trimmedCardNumber.rangeOfCharacter(from: nonDigitsCharacterSet) != nil
        
        guard trimmedCardNumber.count == 16,
              !cardNumber.isEmpty,
              !containsNonDigits else {
            onError?("Card information must be 16 digits.")
            return
        }
        
        // **Check for duplicate card number**
        let isDuplicate = debitCardHelper.debitCards.contains { $0.cardNumber == cardNumber }
        
        guard !isDuplicate else {
            onError?("A card with this number already exists.")
            return
        }
        
        // Add the new card if it's not a duplicate
        let debitCard = DebitCard(cardNumber: cardNumber)
        debitCardHelper.addDebitCardToCustomer(debitCard)
        fetchData()
        onSuccess?("Card has been added")
    }
    
    func getReceiverCardsExcluding(cardNumber: String) -> [DebitCard] {
        return debitCardHelper.debitCards.filter { $0.cardNumber != cardNumber }
    }

    func getCardListCount() -> Int {
        return cardList.count
    }

    func getCardListItemViewModel(at index: Int) -> CardListItemViewModel {
        return cardList[index]
    }
    
    func removeDebitCard(at index: Int, reason: DeletionReason? = nil, customReason: String? = nil) {
        let cardNumber = cardList[index].cardNumber
        let deletionReason = customReason ?? reason?.description ?? "No reason provided"
        debitCardHelper.removeDebitCardFromCustomer(cardNumber, reason: deletionReason)
        fetchData()
        onSuccess?("Selected card has been deleted.")
    }
}
