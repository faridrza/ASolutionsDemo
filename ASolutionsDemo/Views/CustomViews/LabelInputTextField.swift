//
//  LabelInputTextField.swift
//  ASolutionsDemo
//
//  Created by Farid Rzayev on 25.09.24.
//


import SnapKit

struct LabelInputTextFieldModel {
    let title: String
    let placeholder: String
}

class LabelInputTextField: UIView {
    
    var inputText: String {
        return inputTextField.text ?? .empty
    }
    
    private lazy var stackView: UIStackView = .build {
        $0.axis = .vertical
        $0.spacing = 4
    }
    
    private lazy var label: UILabel = .build {
        $0.textColor = AppColors.textSecondary
        $0.font = AppFonts.body
    }
    
    lazy var inputTextField: UITextField = .build {
        $0.textColor = AppColors.textPrimary
        $0.font = AppFonts.body
        $0.borderStyle = .none
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray4.cgColor
        $0.backgroundColor = AppColors.background
        $0.setLeftPaddingPoints(10)
        $0.setRightPaddingPoints(10)
        $0.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ item: LabelInputTextFieldModel) {
        label.text = item.title
        inputTextField.placeholder = item.placeholder
    }
}

private extension LabelInputTextField {
    func addViews() {
        addSubviewSnp(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        [label, inputTextField].forEach(stackView.addArrangedSubview)
    }
}
