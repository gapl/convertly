//
//  NetworkingError.swift
//  Convertly
//
//  Created by Gasper Kolenc on 11/14/20.
//

enum NetworkingError: Error {
    case malformedUrl
    case apiError(underlyingError: Error)
}
