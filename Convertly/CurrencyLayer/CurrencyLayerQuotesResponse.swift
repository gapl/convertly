//
//  CurrencyLayerQuotesResponse.swift
//  Convertly
//
//  Created by Gasper Kolenc on 11/14/20.
//

struct QuotesResponse: Decodable {
    let quotes: [Quote]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
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
    }

    private enum CodingKeys: String, CodingKey {
        case source
        case quotes
    }
}
