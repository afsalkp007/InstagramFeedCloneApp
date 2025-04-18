//
//  FeedLoaderCacheDecorator.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 18/04/2025.
//

import Foundation

final class FeedLoaderCacheDecorator: DataLoader {
    private let decoratee: DataLoader
    private let cache: DataSaver
    
    init(decoratee: DataLoader, cache: DataSaver) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    func loadPosts(completion: @escaping (DataLoader.Result) -> Void) {
        decoratee.loadPosts { [weak self] result in
            completion(result.map { posts in
                self?.cache.savePosts(posts)
                return posts
            })
        }
    }
}
