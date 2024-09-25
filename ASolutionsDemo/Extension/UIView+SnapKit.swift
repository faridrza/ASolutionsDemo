//
//  UIView+SnapKit.swift
//  ASolutionsDemo
//
//  Created by Farid Rzayev on 25.09.24.
//


import SnapKit

extension UIView {
    func addSubviewSnp(_ view: UIView, insets: UIEdgeInsets = .zero) {
        addSubview(view)
        view.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(insets.left)
            make.top.equalToSuperview().inset(insets.top)
            make.trailing.equalToSuperview().inset(insets.right)
            make.bottom.equalToSuperview().inset(insets.bottom)
        }
    }
}
