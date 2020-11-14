//
//  ViewController.swift
//  Convertly
//
//  Created by Gasper Kolenc on 11/14/20.
//

import UIKit

class CurrencyViewController: UIViewController {
    private let viewModel: CurrencyViewModel

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
    }
}
