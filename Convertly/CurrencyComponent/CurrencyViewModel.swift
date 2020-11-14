//
//  CurrencyViewModel.swift
//  Convertly
//
//  Created by Gasper Kolenc on 11/14/20.
//

import Foundation

class CurrencyViewModel {
    private let networkingClient: NetworkingClient

    init(networkingClient: NetworkingClient) {
        self.networkingClient = networkingClient
    }
}
