//
//  File.swift
//  ASolutionsDemo
//
//  Created by Farid Rzayev on 25.09.24.
//

import UIKit

// MARK: - UITableViewDelegate, UITableViewDataSource

extension CardListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return viewModel.getCardListCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: CardListItemTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.delegate = self
        let cardItemViewModel = viewModel.getCardListItemViewModel(at: indexPath.row)
        cell.configure(with: cardItemViewModel)
        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completionHandler in
            self?.presentDeletionReasonActionSheet(forRowAt: indexPath)
            completionHandler(true)
        }
        let config = UISwipeActionsConfiguration(actions: [action])
        return config
    }
}

extension CardListViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        // Ensure it's the alert's text field
        guard textField.tag == 0 else { return true }
        
        // Enforce digit-only input
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        if !allowedCharacters.isSuperset(of: characterSet) {
            return false
        }

        // Get the current text
        let currentText = textField.text ?? .empty
        // Apply the replacement
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        // Remove any non-digit characters
        let cleanedText = updatedText.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        // Enforce max length of 16 digits
        if cleanedText.count > 16 {
            return false
        }
        // Format the card number
        let formattedText = cleanedText.textPattern()
        textField.text = formattedText
        return false
    }
}
