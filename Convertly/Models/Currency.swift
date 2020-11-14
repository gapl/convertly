//
//  Currency.swift
//  Convertly
//
//  Created by Gasper Kolenc on 11/14/20.
//

struct Currency {
    /// 3 letter currency code, i.e. `USD`.
    let code: String

    /// Name of currency, i.e. `United States Dollar`.
    let name: String?

    init?(code: String, name: String? = nil) {
        guard !code.isEmpty else {
            // Code can't be an empty string.
            return nil
        }

        self.code = code
        self.name = name
    }
}
