//
//  BaseButton.swift
//  ASolutionsDemo
//
//  Created by Farid Rzayev on 25.09.24.
//


import UIKit

class BaseButton: UIButton {
    
    var buttonEnabled: Bool = true {
        didSet {
            changeStateStyle()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDesign()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension BaseButton {
    func setupDesign() {
        backgroundColor = AppColors.primary
        setTitleColor(.white, for: .normal)
        titleLabel?.font = AppFonts.button
        layer.cornerRadius = 8
        layer.masksToBounds = false
        // Add shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
    }
    
    func changeStateStyle() {
        isEnabled = buttonEnabled
        backgroundColor = buttonEnabled ? AppColors.primary : AppColors.primary.withAlphaComponent(0.5)
    }
}
