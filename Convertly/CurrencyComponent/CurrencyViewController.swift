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

        // Respond to collection view events
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(QuoteCellView.self, forCellWithReuseIdentifier: .reuseIdentifierQuote)

        bindActions()
        bindValues()
    }

    private var sub: Any?

    private func bindActions() {
        mainView.currencySelectionPickerView.delegate = self
        mainView.currencySelectionDoneButton.target = self
        mainView.currencySelectionDoneButton.action = #selector(endEditing)

        // Update amount to convert whenever text field text changes.
        NotificationCenter
            .default
            .publisher(for: UITextField.textDidChangeNotification, object: mainView.amountTextField)
            .compactMap { ($0.object as? UITextField)?.text }
            .map { $0.components(separatedBy: CharacterSet.decimalDigits.inverted).joined() }
            .compactMap { Double($0) }
            .sink(receiveValue: viewModel.updated(amount:))
            .store(in: &subscriptions)
    }

    private func bindValues() {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2

        // Update currency value.
        viewModel
            .currencyButtonText
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in self?.mainView.currencySelectionTextField.text = $0 })
            .store(in: &subscriptions)

        // Update text for converting amount.
        viewModel
            .amountToConvert
            .map { numberFormatter.string(from: $0 as NSNumber) }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in self?.mainView.amountTextField.text = $0 })
            .store(in: &subscriptions)

        // Present any errors in an alert view.
        viewModel
            .errorRelay
            .receive(on: DispatchQueue.main)
            .sink { error in
                let alert = UIAlertController(title: "Whoops!", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .cancel))
                self.present(alert, animated: true)
            }
            .store(in: &subscriptions)

        // Reload picker view when available currencies update.
        viewModel
            .currencyList
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.mainView.currencySelectionPickerView.reloadAllComponents()

                // Set current currency as selected.
                if let selectedCurrency = self?.viewModel.selectedCurrency.value ?? Currency(code: "USD"),
                   let selectedIndex = self?.viewModel.currencyList.value.firstIndex(of: selectedCurrency) {
                    self?.mainView.currencySelectionPickerView.selectRow(selectedIndex, inComponent: 0, animated: false)
                }
            })
            .store(in: &subscriptions)

        // Set info label's text.
        viewModel
            .infoText
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in self?.mainView.infoLabel.text = $0 })
            .store(in: &subscriptions)

        // Reload quotes whenever they change.
        Publishers
            .Merge(viewModel.quoteList.map { _ in () }, viewModel.amountToConvert.map { _ in () })
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in self?.mainView.collectionView.reloadData() })
            .store(in: &subscriptions)
    }

    /// Dismiss visible keyboard.
    @objc func endEditing() {
        view.endEditing(true)
    }
}

// MARK: - UIPicker
extension CurrencyViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        max(viewModel.currencyList.value.count, 1)
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard !viewModel.currencyList.value.isEmpty else {
            return "Loading currencies..."
        }

        return viewModel.currencyList.value[row].name
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard !viewModel.currencyList.value.isEmpty else { return }
        viewModel.selected(currency: viewModel.currencyList.value[row])
    }
}

// MARK: - UICollectionView
extension CurrencyViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {

        viewModel.quoteList.value.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: .reuseIdentifierQuote,
                for: indexPath) as? QuoteCellView else {
            fatalError("Unable to dequeue QuoteCellView.")
        }

        cell.configure(with: viewModel.cellViewModel(for: indexPath))
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let numberOfItemsInRow: CGFloat = 3
        let availableWidth = collectionView.bounds.size.width - (numberOfItemsInRow - 1) * .itemSpacing
        let itemWidth = floor(availableWidth / numberOfItemsInRow)
        return CGSize(width: itemWidth, height: itemWidth)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        .itemSpacing
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        .itemSpacing
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // Dismiss keyboard on scroll view drag.
        endEditing()
    }
}

private extension String {
    static let reuseIdentifierQuote = "QuoteCell"
}

private extension CGFloat {
    static let itemSpacing: CGFloat = 12
}
