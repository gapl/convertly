//
//  SimpleLocalCache.swift
//  Convertly
//
//  Created by Gasper Kolenc on 11/14/20.
//

import Foundation

class SimpleLocalCache: Cache {
    private let ttl: TimeInterval
    private var cache: [URL: CacheObject] = [:]

    private struct CacheObject {
        let response: Any
        let timestamp: Date
    }

    /// Creates a simple local cache with a local dictionary.
    ///
    /// - Parameter ttl: Time to live, i.e. how long an object should be persisted in cache. By default it's 30 min.
    init(ttl: TimeInterval = 1800) {
        self.ttl = ttl
    }

    func cache<T>(response: T, for url: URL) {
        cache[url] = CacheObject(response: response, timestamp: Date())
    }

    func cached<T>(for url: URL) -> T? {
        guard let cacheObject = cache[url] else {
            debugPrint("[CACHE] No cached response for \(url)")
            return nil
        }

        guard Date().timeIntervalSince(cacheObject.timestamp) < ttl else {
            // This cache object has expired, remove from cache.
            cache[url] = nil
            debugPrint("[CACHE] Cached response was stale for \(url)")
            return nil
        }

        // Everything seems okay, return cache response.
        debugPrint("[CACHE] Returning cached response for \(url)")
        return cacheObject.response as? T
    }
}
