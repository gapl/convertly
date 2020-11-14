//
//  QuoteCellViewModel.swift
//  Convertly
//
//  Created by Gasper Kolenc on 11/14/20.
//

import Foundation

struct QuoteCellViewModel {
    var quoteText: String
    var currencyText: String

    /// Number formatter is defined as a static variable to not instantiate one for every cell view model.
    private static var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        return numberFormatter
    }

    init(quote: Quote, amount: Double) {
        quoteText = Self.numberFormatter.string(from: quote.quote * amount as NSNumber) ?? "..."
        currencyText = quote.destination.code.uppercased()
    }
}
