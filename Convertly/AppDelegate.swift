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

        // Prepare main view controller
        let viewModel = CurrencyViewModel()
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
