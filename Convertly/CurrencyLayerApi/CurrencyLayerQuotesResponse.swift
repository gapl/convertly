//
//  CurrencyLayerQuotesResponse.swift
//  Convertly
//
//  Created by Gasper Kolenc on 11/14/20.
//

struct QuotesResponse: Decodable {
    let quotes: [Quote]
    let error: Error?

    struct Error: Decodable {
        let code: Int
        let info: String
    }

    init(quotes: [Quote]) {
        self.quotes = quotes
        self.error = nil
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let success = try container.decode(Bool.self, forKey: .success)
        guard success else {
            quotes = []
            error = try container.decode(Error.self, forKey: .error)
            return
        }
        
        let sourceCode = try container.decode(String.self, forKey: .source)
        let quoteMap = try container.decode([String:Double].self, forKey: .quotes)
        self.quotes = quoteMap
            .compactMap {
                Quote(
                    source: Currency(code: sourceCode),
                    destination: Currency(code: $0.replacingOccurrences(of: sourceCode, with: "")),
                    quote: $1)
            }
            .sorted(by: { $0.destination.code < $1.destination.code })
        self.error = nil
    }

    private enum CodingKeys: String, CodingKey {
        case success
        case error
        case source
        case quotes
    }
}
