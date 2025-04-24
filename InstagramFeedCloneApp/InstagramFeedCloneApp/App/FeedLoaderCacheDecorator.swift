//
//  FeedLoaderCacheDecorator.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 18/04/2025.
//

import Foundation
import InstagramFeedClone

final class FeedLoaderCacheDecorator: FeedLoader {
    private let decoratee: FeedLoader
    private let cache: FeedCache
    
    init(decoratee: FeedLoader, cache: FeedCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    func loadFeed(completion: @escaping (FeedLoader.Result) -> Void) {
        decoratee.loadFeed { [weak self] result in
            completion(result.map { posts in
                self?.cache.saveIgnoringResult(posts)
                return posts
            })
        }
    }
}

extension FeedCache {
    func saveIgnoringResult(_ posts: [Post]) {
        savePosts(posts) { _ in }
    }
}
