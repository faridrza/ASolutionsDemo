//
//  CustomerHelper.swift
//  ASolutionsDemo
//
//  Created by Farid Rzayev on 25.09.24.
//


import Foundation

class CustomerHelper {
    
    static let shared = CustomerHelper()
    
    private var customer: Customer? = nil
    
    func createCustomer(with model: Customer) {
        customer = model
    }
    
    func getCustomer() -> Customer {
        return customer ?? Customer(name: .empty,
                                    surname: .empty,
                                    birthDate: .empty,
                                    gsmNumber: .empty)
    }
}
