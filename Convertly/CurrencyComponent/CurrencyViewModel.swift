//
//  CurrencyViewModel.swift
//  Convertly
//
//  Created by Gasper Kolenc on 11/14/20.
//

import Foundation
import Combine

class CurrencyViewModel {
    private let networkingClient: NetworkingClient
    private var subscriptions = Set<AnyCancellable>()

    /// Amount that should be converted from `selectedCurrency`.
    var amountToConvert = CurrentValueSubject<Double, Never>(1)

    /// Currently selected currency.
    var selectedCurrency = CurrentValueSubject<Currency?, Never>(nil)

    /// List of quotes for current `selectedCurrency`.
    var quoteList = CurrentValueSubject<[Quote], Never>([])

    /// List of available currencies.
    var currencyList = CurrentValueSubject<[Currency], Never>([])

    /// Error relay that need to be presented to the user.
    var errorRelay = PassthroughSubject<String, Never>()

    /// Info text to display.
    var infoText = CurrentValueSubject<String?, Never>("Loading...")

    /// String value to bind to UI.
    var currencyButtonText: Publishers.Map<CurrentValueSubject<Currency?, Never>, String> {
        selectedCurrency.map { $0?.code ?? "..." }
    }

    init(networkingClient: NetworkingClient) {
        self.networkingClient = networkingClient

        // Load list of currencies at init time.
        loadCurrencies()

        // Load quotes when selection changes.
        loadQuotes()
    }

    func cellViewModel(for indexPath: IndexPath) -> QuoteCellViewModel {
        QuoteCellViewModel(quote: quoteList.value[indexPath.item], amount: amountToConvert.value)
    }
}

// MARK: - User actions
extension CurrencyViewModel {
    func selected(currency: Currency) {
        guard selectedCurrency.value != currency else { return }
        selectedCurrency.send(currency)
    }

    func updated(amount: Double) {
        amountToConvert.send(amount / 100)
    }
}

// MARK: - API requests
private extension CurrencyViewModel {
    /// Loads list of currencies, then stores them in `currencyList` and sets initial `selectedCurrency` to `JPY`.
    func loadCurrencies() {
        networkingClient
            .request(CurrencyLayerApi.listCurrencies)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break

                case .failure(let error):
                    debugPrint("[Error] Fetch error: \(error)")
                    self?.errorRelay.send("There was an error fetching all available currencies. Please restart the app.")
                }
            } receiveValue: { [weak self] (response: ListResponse) in
                let currencies = response.currencies
                self?.currencyList.send(currencies)

                // Default to selecting USD, only supported one in the free payment plan.
                self?.selectedCurrency.send(currencies.first(where: { $0.code == "USD" }) ?? currencies.first)
            }
            .store(in: &subscriptions)
    }

    func loadQuotes() {
        selectedCurrency
            // Debounce changes for 0.5 second.
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)

            // Empty list of current quotes when selected currency changes.
            .handleEvents(receiveOutput: { _ in
                self.quoteList.send([])
                self.infoText.send("Loading...")
            })

            // Fetch rates for selected currency.
            .compactMap { $0 }
            .map { self.networkingClient.request(CurrencyLayerApi.exchangeRates(sourceCurrency: $0)) }

            // We are interested in the latest subscription only.
            .switchToLatest()

            // Present fetched quotes.
            .sink { completion in
                switch completion {
                case .finished:
                    break

                case .failure(let error):
                    debugPrint("[Error] Fetch error: \(error)")
                    self.errorRelay.send("There was an error fetching all available quotes. Please try again.")
                }
            } receiveValue: { (response: QuotesResponse) in
                if let error = response.error, error.code == 105 {
                    // Access Restricted - Your current Subscription Plan does not support Source Currency Switching.
                    self.errorRelay.send("""
                        You're currently using CurrencyLayer's Free plan. Only available currency conversion on the \
                        Free plan is from USD. To see conversion rates from other currencies, please update access \
                        key in `CurrencyLayerApi` file. You can still convert different USD amounts by changing \
                        amount value and using currency USD.
                        """)
                    self.infoText.send("Something went wrong, try again.")
                } else if let error = response.error {
                    self.errorRelay.send(error.info)
                    self.infoText.send("Something went wrong, try again.")
                } else {
                    self.infoText.send(nil)
                    self.quoteList.send(response.quotes)
                }
            }
            .store(in: &subscriptions)
    }
}
