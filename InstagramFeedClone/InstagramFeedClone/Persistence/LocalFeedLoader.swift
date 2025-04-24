//
//  CacheManager.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 18/04/2025.
//

import Foundation

public final class LocalFeedLoader {
    private let store: FeedStore
    
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
                .mapError { error in
                    return error
                }.flatMap { posts in
                    return .success(posts)
                })
        }
    }
}

extension LocalFeedLoader: FeedCache {
    public typealias SaveResult = FeedCache.Result
    
    public func savePosts(_ posts: [Post], completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedData { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                self.store.insert(posts, completion: completion)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
