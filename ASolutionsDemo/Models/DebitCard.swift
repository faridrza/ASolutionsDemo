//
//  DebitCard.swift
//  ASolutionsDemo
//
//  Created by Farid Rzayev on 25.09.24.
//

import Foundation

struct DebitCard {
    let cardNumber: String
    var balance: Double
    
    init(cardNumber: String, balance: Double = 10) {
        self.cardNumber = cardNumber
        self.balance = balance
    }
}
