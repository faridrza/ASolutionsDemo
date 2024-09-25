//
//  File.swift
//  ASolutionsDemo
//
//  Created by Farid Rzayev on 25.09.24.
//


import UIKit

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = radius
        layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
    }
}