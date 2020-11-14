//
//  Quote.swift
//  Convertly
//
//  Created by Gasper Kolenc on 11/14/20.
//

struct Quote {
    /// Source currency.
    let source: Currency

    /// Destination currency.
    let destination: Currency

    /// Quote from `source` currency to `destination` currency.
    let quote: Double

    init?(source: Currency?, destination: Currency?, quote: Double) {
        guard let source = source, let destination = destination else {
            // Optional initializier that can accept optional parameters, but fails if they are actually `nil`.
            return nil
        }

        self.source = source
        self.destination = destination
        self.quote = quote
    }
}
