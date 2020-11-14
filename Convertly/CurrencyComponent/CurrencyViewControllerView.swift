//
//  CurrencyViewControllerView.swift
//  Convertly
//
//  Created by Gasper Kolenc on 11/14/20.
//

import UIKit

extension CurrencyViewController {
    class View: UIView {
        let amountTextField = UITextField()
        let currencySelectionTextField = UITextField()
        let currencySelectionPickerView = UIPickerView()
        let currencySelectionDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        let loadingLabel = UILabel()

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
            amountTextField.font = .boldSystemFont(ofSize: 20)
            amountTextField.textAlignment = .right
            amountTextField.backgroundColor = .interactiveElementBackground
            amountTextField.textColor = .interactiveElementText
            amountTextField.layer.cornerRadius = 4
            amountTextField.layer.masksToBounds = true
            amountTextField.keyboardType = .numberPad
            amountTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
            amountTextField.leftViewMode = .always
            amountTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
            amountTextField.rightViewMode = .always

            currencySelectionTextField.font = .boldSystemFont(ofSize: 20)
            currencySelectionTextField.textAlignment = .center
            currencySelectionTextField.backgroundColor = .interactiveElementBackground
            currencySelectionTextField.textColor = .interactiveElementText
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

            loadingLabel.text = "Loading..."
            loadingLabel.font = .systemFont(ofSize: 16)
            loadingLabel.textAlignment = .center
            loadingLabel.textColor = .staticElementText
        }

        private func configureLayout() {
            addSubview(currencySelectionTextField)
            currencySelectionTextField.topAnchor.constraint(equalTo: safeTopAnchor, constant: 24).activate
            currencySelectionTextField.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: -24).activate
            currencySelectionTextField.heightAnchor.constraint(equalToConstant: 50).activate
            currencySelectionTextField.widthAnchor.constraint(equalToConstant: 80).activate

            addSubview(amountTextField)
            amountTextField.topAnchor.constraint(equalTo: safeTopAnchor, constant: 24).activate
            amountTextField.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: 24).activate
            amountTextField.trailingAnchor.constraint(equalTo: currencySelectionTextField.leadingAnchor, constant: -24).activate
            amountTextField.heightAnchor.constraint(equalToConstant: 50).activate

            addSubview(collectionView)
            collectionView.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 24).activate
            collectionView.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: 24).activate
            collectionView.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: -24).activate
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).activate

            addSubview(loadingLabel)
            loadingLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).activate
            loadingLabel.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor, constant: -24).activate
        }
    }
}
