//
//  CurrencyViewControllerView.swift
//  Convertly
//
//  Created by Gasper Kolenc on 11/14/20.
//

import UIKit

extension CurrencyViewController {
    class View: UIView {
        let textField = UITextField()
        let currencySelectionButton = UIButton(type: .custom)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

        init() {
            super.init(frame: .zero)
            backgroundColor = .background

            configureSubviews()
            configureLayout()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func configureSubviews() {
            textField.font = .boldSystemFont(ofSize: 20)
            textField.textAlignment = .right
            textField.backgroundColor = .interactiveElementBackground
            textField.textColor = .interactiveElementTextColor
            textField.layer.cornerRadius = 4
            textField.layer.masksToBounds = true
            textField.keyboardType = .numberPad
            textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
            textField.leftViewMode = .always
            textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
            textField.rightViewMode = .always

            currencySelectionButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
            currencySelectionButton.backgroundColor = .interactiveElementBackground
            currencySelectionButton.setTitleColor(.interactiveElementTextColor, for: .normal)
            currencySelectionButton.layer.cornerRadius = 4
            currencySelectionButton.layer.masksToBounds = true

            collectionView.backgroundColor = backgroundColor
            collectionView.alwaysBounceVertical = true
        }

        private func configureLayout() {
            addSubview(currencySelectionButton)
            currencySelectionButton.topAnchor.constraint(equalTo: safeTopAnchor, constant: 24).activate
            currencySelectionButton.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: -24).activate
            currencySelectionButton.heightAnchor.constraint(equalToConstant: 50).activate
            currencySelectionButton.widthAnchor.constraint(equalToConstant: 80).activate

            addSubview(textField)
            textField.topAnchor.constraint(equalTo: safeTopAnchor, constant: 24).activate
            textField.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: 24).activate
            textField.trailingAnchor.constraint(equalTo: currencySelectionButton.leadingAnchor, constant: -24).activate
            textField.heightAnchor.constraint(equalToConstant: 50).activate

            addSubview(collectionView)
            collectionView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24).activate
            collectionView.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: 24).activate
            collectionView.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: -24).activate
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).activate
        }
    }
}
