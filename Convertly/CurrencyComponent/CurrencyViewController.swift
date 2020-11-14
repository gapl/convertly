//
//  ViewController.swift
//  Convertly
//
//  Created by Gasper Kolenc on 11/14/20.
//

import UIKit
import Combine

class CurrencyViewController: UIViewController {
    private let viewModel: CurrencyViewModel
    private var subscriptions = Set<AnyCancellable>()

    private var mainView: CurrencyViewController.View {
        // swiftlint:disable:next force_cast
        return view as! CurrencyViewController.View
    }

    init(viewModel: CurrencyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = CurrencyViewController.View()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindActions()
        bindValues()
    }

    private var sub: Any?

    private func bindActions() {
        mainView
            .currencySelectionButton
            .addTarget(viewModel, action: #selector(CurrencyViewModel.selectionButtonTapped), for: .touchUpInside)
    }

    private func bindValues() {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2

        viewModel
            .currencyButtonText
            .map { ($0, UIControl.State.normal) }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: mainView.currencySelectionButton.setTitle)
            .store(in: &subscriptions)

        viewModel
            .amountToConvert
            .map { numberFormatter.string(from: $0 as NSNumber) }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in self?.mainView.textField.text = $0 })
            .store(in: &subscriptions)

        viewModel
            .errorRelay
            .receive(on: DispatchQueue.main)
            .sink { error in
                let alert = UIAlertController(title: "Whoops!", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .cancel))
                self.present(alert, animated: true)
            }
            .store(in: &subscriptions)
    }
}
