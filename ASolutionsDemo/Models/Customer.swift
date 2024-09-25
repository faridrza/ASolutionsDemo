//
//  Customer.swift
//  ASolutionsDemo
//
//  Created by Farid Rzayev on 25.09.24.
//

import Foundation

struct Customer {
    let name: String
    let surname: String
    let birthDate: String
    let gsmNumber: String
    var debitCards: [DebitCard]
    
    init(name: String, surname: String, birthDate: String, gsmNumber: String) {
        self.name = name
        self.surname = surname
        self.birthDate = birthDate
        self.gsmNumber = gsmNumber
        self.debitCards = []
    }
}
