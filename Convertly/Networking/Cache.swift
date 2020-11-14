//
//  Cacge.swift
//  Convertly
//
//  Created by Gasper Kolenc on 11/14/20.
//

import Foundation

protocol Cache {
    /// Cache response for given url.
    ///
    /// - Parameters:
    ///   - response: Reponse to cache.
    ///   - url: Url used as cache key.
    func cache<T>(response: T, for url: URL)

    /// Fetch possibly cached response.
    ///
    /// - Parameter url: Url used as cache key.
    func cached<T>(for url: URL) -> T?
}
