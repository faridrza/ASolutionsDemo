//
//  DashboardViewController.swift
//  ASolutionsDemo
//
//  Created by Farid Rzayev on 25.09.24.
//
import UIKit
import TPKeyboardAvoiding

class DashboardViewController: UIViewController {

    private let viewModel = DashboardViewModel()
    private let phoneNumberFormatter = PhoneNumberFormatter()
    
    private lazy var scrollView: TPKeyboardAvoidingScrollView = .build {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }
    
    private lazy var containerStackView: UIStackView = .build {
        $0.axis = .vertical
        $0.spacing = 16
        $0.distribution = .fill
        $0.layoutMargins = UIEdgeInsets(top: 24, left: 16, bottom: 24, right: 16)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    private lazy var datePicker: UIDatePicker = .build {
        $0.maximumDate = Date.maximumBirthDate
        $0.datePickerMode = .date
        $0.preferredDatePickerStyle = .wheels
        $0.addTarget(self, action: #selector(didChangeDatePickerValue), for: .valueChanged)
    }
    
    // Add the toolbar
    private lazy var datePickerToolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(didTapDatePickerDone)
        )
        
        // Add a flexible space to align the Done button to the right
        let flexibleSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        return toolbar
    }()
    
    private lazy var nameField: LabelInputTextField = .build {
        $0.configure(.init(title: "Name", placeholder: "Please enter your name"))
        $0.inputTextField.delegate = self
        $0.inputTextField.tag = DashboardInputTypes.name.rawValue
    }
    
    private lazy var surnameField: LabelInputTextField = .build {
        $0.configure(.init(title: "Surname", placeholder: "Please enter your surname"))
        $0.inputTextField.delegate = self
        $0.inputTextField.tag = DashboardInputTypes.surname.rawValue
    }
    
    private lazy var birthdateField: LabelInputTextField = .build {
        $0.configure(.init(title: "Birthdate", placeholder: "Please select your birthdate"))
        $0.inputTextField.inputView = datePicker
        $0.inputTextField.inputAccessoryView = datePickerToolbar
        $0.inputTextField.delegate = self
        $0.inputTextField.tag = DashboardInputTypes.birthdate.rawValue
        $0.inputTextField.tintColor = .clear
        $0.inputTextField.addTarget(self, action: #selector(birthdateFieldTapped), for: .touchDown)
    }
    
    private lazy var phoneNumberField: LabelInputTextField = .build {
        $0.configure(.init(title: "Phone number", placeholder: "Please enter your phone number"))
        $0.inputTextField.keyboardType = .phonePad
        $0.inputTextField.text = "+994"
        $0.inputTextField.delegate = self
        $0.inputTextField.tag = DashboardInputTypes.phoneNumber.rawValue
        $0.inputTextField.addTarget(self, action: #selector(phoneNumberFieldDidChange), for: .editingChanged)
    }
    
    private lazy var buttonsWrapperView: UIView = UIView()
    
    private lazy var buttonsStackView: UIStackView = .build {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.distribution = .fillEqually
    }
    
    private lazy var createButton: BaseButton = .build {
        $0.setTitle("Create account", for: .normal)
        $0.buttonEnabled = false
        $0.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.title = "Demo App"
        
        addSubviews()
        setupConstraints()
        
        hideKeyboardWhenTappedAround()
        setupBindings()
        
        // Set initial values
        viewModel.rawPhoneNumber = "+994"
        phoneNumberField.inputTextField.text = "+994"
    }

    private func setupBindings() {
        viewModel.isCreateButtonEnabled = { [weak self] isEnabled in
            DispatchQueue.main.async {
                self?.createButton.buttonEnabled = isEnabled
            }
        }
        
        viewModel.formattedPhoneNumber = { [weak self] formatted in
            DispatchQueue.main.async {
                self?.phoneNumberField.inputTextField.text = formatted
            }
        }
    }
    
    @objc
    func didTapDatePickerDone() {
        // Update the text field with the selected date
        viewModel.birthdate = datePicker.date
        birthdateField.inputTextField.text = datePicker.date.formattedString
        
        // Dismiss the date picker
        birthdateField.inputTextField.resignFirstResponder()
    }
}

// MARK: - Private Methods

private extension DashboardViewController {

    func addSubviews() {
        view.addSubviewSnp(scrollView)
        scrollView.addSubviewSnp(containerStackView)
        
        buttonsWrapperView.addSubview(buttonsStackView)
        buttonsStackView.addSubview(createButton)
        
        [createButton].forEach(buttonsStackView.addArrangedSubview)
        
        [nameField,
         surnameField,
         birthdateField,
         phoneNumberField,
         buttonsWrapperView].forEach(containerStackView.addArrangedSubview)
    }
    
    func setupConstraints() {
        containerStackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        buttonsStackView.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
        }
    }
    
    @objc
    func didChangeDatePickerValue(_ datePicker: UIDatePicker) {
        viewModel.birthdate = datePicker.date
        birthdateField.inputTextField.text = datePicker.date.formattedString
    }
    
    @objc
    func didTapCreateButton() {
        viewModel.createCustomer()
        let vc = CardListViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func phoneNumberFieldDidChange(_ textField: UITextField) {
        let text = textField.text ?? .empty
        viewModel.rawPhoneNumber = text
    }
    
    @objc
    private func birthdateFieldTapped() {
        birthdateField.inputTextField.becomeFirstResponder()
    }
}

// MARK: - UITextFieldDelegate

extension DashboardViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        guard let text = textField.text, let textRange = Range(range, in: text) else {
            return true
        }
        
        let updatedText = text.replacingCharacters(in: textRange, with: string)
        
        switch textField.tag {
        case DashboardInputTypes.name.rawValue:
            viewModel.name = updatedText
            return true
        case DashboardInputTypes.surname.rawValue:
            viewModel.surname = updatedText
            return true
        case DashboardInputTypes.phoneNumber.rawValue:
            // Prevent deletion or modification of the "+994" prefix
            if range.location < 4 {
                return false
            }
            // Only allow digits after the prefix
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            if !allowedCharacters.isSuperset(of: characterSet) {
                return false
            }
            // Enforce maximum length
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            let digitsCount = updatedText.count - 4 // Subtract prefix length
            if digitsCount > 13 {
                return false
            }
            return true
        case DashboardInputTypes.birthdate.rawValue:
            // Prevent manual editing
            return false
        default:
            return true
        }
    }
}
