//
//  AppDelegate.swift
//  Convertly
//
//  Created by Gasper Kolenc on 11/14/20.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: LaunchOptions?) -> Bool {

        // Prepare injectable resources
        let networkingClient = NetworkingClient()

        // Prepare main view controller
        let viewModel = CurrencyViewModel(networkingClient: networkingClient)
        let viewController = CurrencyViewController(viewModel: viewModel)

        // Prepare window
        let window = UIWindow()
        window.frame = UIScreen.main.bounds
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        self.window = window

        return true
    }
}

typealias LaunchOptions = [UIApplication.LaunchOptionsKey: Any]
