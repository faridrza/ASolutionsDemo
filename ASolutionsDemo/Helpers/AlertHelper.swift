//
//  AlertHelper.swift
//  ASolutionsDemo
//
//  Created by Farid Rzayev on 25.09.24.
//


import UIKit

typealias AlertModelCompletion = (String?) -> ()

struct AlertModel {
    let title: String
    let subtitle: String
    let placeholder: String
    let buttonTitle: String
    let completion: AlertModelCompletion
}

class AlertHelper {
    static let shared = AlertHelper()
    
    func createAlertWithTextField(with model: AlertModel, sender: UIViewController?) {
        let alert = UIAlertController(title: model.title, message: model.subtitle, preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = model.placeholder
            textField.delegate = sender as? UITextFieldDelegate 
            textField.keyboardType = .numberPad
        }

        alert.addAction(UIAlertAction(title: model.buttonTitle, style: .default, handler: { [weak alert] (_) in
            if let textField = alert?.textFields?[0] {
                model.completion(textField.text)
            }
        }))

        alert.addAction(UIAlertAction(title: "Close", style: .cancel))

        sender?.present(alert, animated: true, completion: nil)
    }
}
