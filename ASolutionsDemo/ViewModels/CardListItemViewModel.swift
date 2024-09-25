//
//  CardListItemViewModel.swift
//  ASolutionsDemo
//
//  Created by Farid Rzayev on 25.09.24.
//


import Foundation

class CardListItemViewModel {

    private(set) var debitCard: DebitCard

    var cardNumber: String {
        return debitCard.cardNumber
    }

    var balanceText: String {
        return "\(debitCard.balance) AZN"
    }

    init(debitCard: DebitCard) {
        self.debitCard = debitCard
    }
}
