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
        let currencySelectionTextField = UITextField()
        let currencySelectionPickerView = UIPickerView()
        let currencySelectionDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
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

            currencySelectionTextField.font = .boldSystemFont(ofSize: 20)
            currencySelectionTextField.textAlignment = .center
            currencySelectionTextField.backgroundColor = .interactiveElementBackground
            currencySelectionTextField.textColor = .interactiveElementTextColor
            currencySelectionTextField.layer.cornerRadius = 4
            currencySelectionTextField.layer.masksToBounds = true
            currencySelectionTextField.tintColor = .clear
            currencySelectionTextField.inputView = currencySelectionPickerView

            let toolBar = UIToolbar()
            toolBar.sizeToFit()
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            toolBar.setItems([flexibleSpace, currencySelectionDoneButton], animated: true)
            currencySelectionTextField.inputAccessoryView = toolBar

            collectionView.backgroundColor = backgroundColor
            collectionView.alwaysBounceVertical = true
        }

        private func configureLayout() {
            addSubview(currencySelectionTextField)
            currencySelectionTextField.topAnchor.constraint(equalTo: safeTopAnchor, constant: 24).activate
            currencySelectionTextField.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: -24).activate
            currencySelectionTextField.heightAnchor.constraint(equalToConstant: 50).activate
            currencySelectionTextField.widthAnchor.constraint(equalToConstant: 80).activate

            addSubview(textField)
            textField.topAnchor.constraint(equalTo: safeTopAnchor, constant: 24).activate
            textField.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: 24).activate
            textField.trailingAnchor.constraint(equalTo: currencySelectionTextField.leadingAnchor, constant: -24).activate
            textField.heightAnchor.constraint(equalToConstant: 50).activate

            addSubview(collectionView)
            collectionView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24).activate
            collectionView.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: 24).activate
            collectionView.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: -24).activate
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).activate
        }
    }
}
