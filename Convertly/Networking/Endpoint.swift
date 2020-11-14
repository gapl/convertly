//
//  Endpoint.swift
//  Convertly
//
//  Created by Gasper Kolenc on 11/14/20.
//

protocol Endpoint {
    var path: String { get }
    var baseURL: String { get }
    var queryParameters: [String: Any] { get }
}
