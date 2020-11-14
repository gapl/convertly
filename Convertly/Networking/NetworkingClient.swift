//
//  NetworkingClient.swift
//  Convertly
//
//  Created by Gasper Kolenc on 11/14/20.
//

import Foundation
import Combine

struct NetworkingClient {
    /// Perform url request with given endpoint.
    ///
    /// - Parameter endpoint: Endpoint for which to perform a request.
    /// - Returns: `Publisher` with decoded `T` object as result.
    func request<T>(_ endpoint: Endpoint) -> AnyPublisher<T, NetworkingError> where T: Decodable {
        guard var urlComponents = URLComponents(string: endpoint.baseURL + endpoint.path) else {
            // If we can't form a `URLComponents` object, it's a malformed url error.
            return Fail(error: NetworkingError.malformedUrl).eraseToAnyPublisher()
        }

        // Encode query parameters
        if endpoint.queryParameters.count > 0 {
            urlComponents.queryItems = endpoint
                .queryParameters
                .map { URLQueryItem(name: $0.0, value: String(describing: $0.1)) }
            urlComponents.percentEncodedQuery = urlComponents
                .percentEncodedQuery?
                .replacingOccurrences(of: "+", with: "%2B")
        }

        guard let url = urlComponents.url else {
            // If we can't extract a `URL` object, it's a malformed url error.
            return Fail(error: NetworkingError.malformedUrl).eraseToAnyPublisher()
        }

        return URLSession
            .shared
            .dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { return NetworkingError.apiError(underlyingError: $0) }
            .eraseToAnyPublisher()
    }
}
