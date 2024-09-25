//
//  DashboardViewModel.swift
//  ASolutionsDemo
//
//  Created by Farid Rzayev on 25.09.24.
//


import Foundation

class DashboardViewModel {

    // MARK: - Input Properties

    var name: String = .empty {
        didSet {
            validateInputs()
        }
    }

    var surname: String = .empty {
        didSet {
            validateInputs()
        }
    }

    var birthdate: Date? {
        didSet {
            birthdateString = birthdate?.formattedString ?? .empty
            validateInputs()
        }
    }

    var birthdateString: String = .empty

    var rawPhoneNumber: String = .empty {
        didSet {
            print("rawPhoneNumber updated: \(rawPhoneNumber)")
            formatPhoneNumber()
            validateInputs()
        }
    }

    // MARK: - Output Callbacks

    var formattedPhoneNumber: ((String) -> Void)?
    var isCreateButtonEnabled: ((Bool) -> Void)?

    // MARK: - Private Properties

    private let phoneNumberFormatter = PhoneNumberFormatter()

    // MARK: - Public Methods

    func createCustomer() {
        let customer = Customer(
            name: name,
            surname: surname,
            birthDate: birthdateString,
            gsmNumber: rawPhoneNumber
        )
        CustomerHelper.shared.createCustomer(with: customer)
    }

    // MARK: - Private Methods

    private func validateInputs() {
        let cleanedPhoneNumber = PhoneHelper.cleanPhoneNumber(number: rawPhoneNumber)
        let isValidPhoneNumber = cleanedPhoneNumber.count == 12 // "+994" + 9 digits
        let isValid = !name.isEmpty &&
            !surname.isEmpty &&
            !birthdateString.isEmpty &&
            isValidPhoneNumber
        isCreateButtonEnabled?(isValid)
    }

    private func formatPhoneNumber() {
        let formatted = phoneNumberFormatter.fullFormat(phone: rawPhoneNumber)
        formattedPhoneNumber?(formatted)
    }
}
