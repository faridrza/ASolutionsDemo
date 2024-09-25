//
//  PhoneNumberFormatter.swift
//  ASolutionsDemo
//
//  Created by Farid Rzayev on 25.09.24.
//


import Foundation

protocol PhoneNumberFormatterProtocol {
    
    var countryPrefix: String { get }
    
    func format(phone: String) -> String
    
    func fullFormat(phone: String) -> String
    
    func rawPhone(from formattedPhone: String) -> String
    
    func isFulfilled(phone: String) -> Bool
}

struct PhoneNumberFormatter: PhoneNumberFormatterProtocol {
    
    private let inputMask = "XX XXX-XX-XX"
    
    private let fullMask = "+XXX XX XXX-XX-XX"
    
    let countryPrefix = "+994"
    
    func format(phone: String) -> String {
        return PhoneHelper.formattedNumber(number: phone, mask: inputMask)
    }
    
    func fullFormat(phone: String) -> String {
        return PhoneHelper.formattedNumber(number: phone, mask: fullMask)
    }
    
    func rawPhone(from formattedPhone: String) -> String {
        return PhoneHelper.cleanPhoneNumber(number: formattedPhone)
    }
    
    func isFulfilled(phone: String) -> Bool {
        return phone.count == fullMask.count { $0 == "X" }
    }
}
