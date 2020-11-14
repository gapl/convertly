//
//  QuoteCellView.swift
//  Convertly
//
//  Created by Gasper Kolenc on 11/14/20.
//

import UIKit

class QuoteCellView: UICollectionViewCell {
    private let quoteLabel = UILabel()
    private let currencyLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureSubviews()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with viewModel: QuoteCellViewModel) {
        quoteLabel.text = viewModel.quoteText
        currencyLabel.text = viewModel.currencyText
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        quoteLabel.text = "..."
        currencyLabel.text = "..."
    }

    private func configureSubviews() {
        contentView.backgroundColor = .cellBackground
        contentView.layer.cornerRadius = 4
        contentView.layer.masksToBounds = true

        quoteLabel.text = "..."
        quoteLabel.font = .boldSystemFont(ofSize: 20)
        quoteLabel.textAlignment = .center
        quoteLabel.textColor = .cellTitle
        quoteLabel.adjustsFontSizeToFitWidth = true

        currencyLabel.text = "..."
        currencyLabel.font = .boldSystemFont(ofSize: 12)
        currencyLabel.textAlignment = .center
        currencyLabel.textColor = .cellSubtitle
    }

    private func configureLayout() {
        contentView.addSubview(quoteLabel)
        quoteLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4).activate
        quoteLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4).activate
        quoteLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -14).activate

        contentView.addSubview(currencyLabel)
        currencyLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).activate
        currencyLabel.topAnchor.constraint(equalTo: quoteLabel.bottomAnchor, constant: 12).activate
    }
}
