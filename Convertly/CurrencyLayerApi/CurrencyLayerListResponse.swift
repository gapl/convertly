//
//  CurrencyLayerListResponse.swift
//  Convertly
//
//  Created by Gasper Kolenc on 11/14/20.
//

struct ListResponse: Decodable {
    let currencies: [Currency]
    let error: Error?

    struct Error: Decodable {
        let code: Int
        let info: String
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let success = try container.decode(Bool.self, forKey: .success)
        guard success else {
            currencies = []
            error = try container.decode(Error.self, forKey: .error)
            return
        }

        let currencyMap = try container.decode([String:String].self, forKey: .currencies)
        self.currencies = currencyMap
            .compactMap { Currency(code: $0, name: $1) }
            .sorted(by: { $0.name ?? $0.code < $1.name ?? $0.code })
        self.error = nil
    }

    private enum CodingKeys: String, CodingKey {
        case success
        case error
        case currencies
    }
}
