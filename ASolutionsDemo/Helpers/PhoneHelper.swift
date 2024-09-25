//
//  PhoneHelper.swift
//  ASolutionsDemo
//
//  Created by Farid Rzayev on 25.09.24.
//


import Foundation

public final class PhoneHelper {
    public static let defaultMask = "+XXX XX XXX XX XX"

    public static func formattedNumber(
        number: String,
        isMaskedNumber: Bool? = false,
        mask: String = defaultMask
    ) -> String {
        var cleanPhoneNumber = number.components(
            separatedBy: CharacterSet.decimalDigits.inverted
        ).joined()

        if isMaskedNumber == true {
            cleanPhoneNumber = number
        }

        var result = String.empty
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }

    public static func cleanPhoneNumber(number: String) -> String {
        number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }

    public static func isFulfilled(number: String, mask: String = defaultMask) -> Bool {
        formattedNumber(number: number).count == mask.count
    }
}
