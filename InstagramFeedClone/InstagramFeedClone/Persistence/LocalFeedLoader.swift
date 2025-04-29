//
//  CacheManager.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 18/04/2025.
//

import Foundation

public final class LocalFeedLoader {
    private let store: FeedStore
    
    public enum Error: Swift.Error {
        case loadError
        case deletionError
    }
    
    public init(store: FeedStore) {
        self.store = store
    }
}

extension LocalFeedLoader: FeedLoader {
    public typealias LoadResult = FeedLoader.Result
    
    public func loadFeed(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] result in
            guard self != nil else { return }
            
            completion(result
                .mapError { _ in Error.loadError }
                .flatMap { return .success($0?.toModels() ?? []) })
        }
    }
}

extension LocalFeedLoader: FeedCache {
    public typealias SaveResult = FeedCache.Result
    
    public func saveFeed(_ feed: [FeedItem], completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedData { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                self.store.insert(feed.toLocal(), completion: completion)
            case .failure:
                completion(.failure(Error.deletionError))
            }
        }
    }
}

extension Array where Element == LocalFeedItem {
    func toModels() -> [FeedItem] {
        return map { FeedItem(id: $0.id, type: $0.type, url: $0.url) }
    }
}

extension Array where Element == FeedItem {
    func toLocal() -> [LocalFeedItem] {
        return map { LocalFeedItem(id: $0.id, type: $0.type, url: $0.url) }
    }
}


