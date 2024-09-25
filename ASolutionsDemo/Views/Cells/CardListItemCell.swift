//
//  CardListItemCell.swift
//  ASolutionsDemo
//
//  Created by Farid Rzayev on 25.09.24.
//


import UIKit

protocol CardListItemCellDelegate: AnyObject {
    func didTapTransferButton(on cell: CardListItemTableViewCell)
}

final class CardListItemTableViewCell: UITableViewCell, Reusable {
    
    weak var delegate: CardListItemCellDelegate?
    
    private var viewModel: CardListItemViewModel?
    
    private lazy var stackView: UIStackView = .build {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fill
    }
    
    private lazy var leftTitleLabel: UILabel = .build {
        $0.textColor = .black.withAlphaComponent(0.6)
    }
    
    private lazy var rightTitleLabel: UILabel = .build {
        $0.textColor = .black
    }
    
    private lazy var transferButton: BaseButton = .build {
        $0.setTitle("Transfer", for: .normal)
        $0.addTarget(self, action: #selector(didTapTransferButton), for: .touchUpInside)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with viewModel: CardListItemViewModel) {
        self.viewModel = viewModel
        leftTitleLabel.text = "**** \(viewModel.cardNumber.suffix(4))"
        rightTitleLabel.text = viewModel.balanceText
    }
}

// MARK: - Private Methods

private extension CardListItemTableViewCell {
    func setup() {
        selectionStyle = .none
        contentView.addSubviewSnp(stackView, insets: .init(top: 8, left: 16, bottom: 8, right: 16))
        contentView.backgroundColor = AppColors.background
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray4.cgColor
        [
            leftTitleLabel,
            rightTitleLabel,
            transferButton
        ].forEach(stackView.addArrangedSubview)
    }
    
    @objc
    func didTapTransferButton() {
        delegate?.didTapTransferButton(on: self)
    }
}
