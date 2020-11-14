//
//  CurrencyLayerApi.swift
//  Convertly
//
//  Created by Gasper Kolenc on 11/14/20.
//

import Foundation

enum CurrencyLayerApi {
    case listCurrencies
    case exchangeRates(sourceCurrency: Currency)
}

extension CurrencyLayerApi: Endpoint {
    var baseURL: String {
        "http://api.currencylayer.com"
    }

    var path: String {
        switch self {
        case .listCurrencies:
            return "/list"

        case .exchangeRates:
            return "/live"
        }
    }

    var queryParameters: [String: Any] {
        switch self {
        case .exchangeRates(let sourceCurrency):
            return [.paramAccessKey: String.accessKey, .paramSource: sourceCurrency.code]

        default:
            return [.paramAccessKey: String.accessKey]
        }
    }
}

private extension String {
    static let accessKey = "62550b1f51789074457a9ca85d0e392a"

    // Parameter names
    static let paramAccessKey = "access_key"
    static let paramSource = "source"
}
