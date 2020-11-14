//
//  CurrencyLayerListResponse.swift
//  Convertly
//
//  Created by Gasper Kolenc on 11/14/20.
//

struct ListResponse: Decodable {
    let currencies: [Currency]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let currencyMap = try container.decode([String:String].self, forKey: .currencies)
        self.currencies = currencyMap
            .compactMap { Currency(code: $0, name: $1) }
            .sorted(by: { $0.code < $1.code })
    }

    private enum CodingKeys: String, CodingKey {
        case currencies
    }
}
