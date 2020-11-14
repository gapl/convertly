//
//  ConvertlyTests.swift
//  ConvertlyTests
//
//  Created by Gasper Kolenc on 11/14/20.
//

import XCTest
@testable import Convertly

class CurrencyViewModelTest: XCTestCase {
    private let viewModel = CurrencyViewModel(networkingClient: NetworkingClient(cache: SimpleLocalCache()))

    func testSelectingCurrency() {
        let newCurrency = Currency(code: "GAS")!
        viewModel.selected(currency: newCurrency)
        XCTAssertEqual(newCurrency, viewModel.selectedCurrency.value)
    }

    func testUpdatingAmount() {
        let newAmount: Double = 1337
        viewModel.updated(amount: newAmount)

        let expectedAmount:Double = 13.37
        XCTAssertEqual(expectedAmount, viewModel.amountToConvert.value)
    }
}
