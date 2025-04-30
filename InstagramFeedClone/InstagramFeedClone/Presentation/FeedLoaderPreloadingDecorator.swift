//
//  FeedLoaderPreloadingDecorator.swift
//  InstagramFeedClone
//
//  Created by Mohamed Afsal on 30/04/2025.
//

import Foundation

final class FeedLoaderPreloadingDecorator: FeedLoader {
    private let feedLoader: FeedLoader
    private let delegate: FeedPreloadable
    
    init(feedLoader: FeedLoader, delegate: FeedPreloadable) {
        self.feedLoader = feedLoader
        self.delegate = delegate
    }
    
    func loadFeed(completion: @escaping (FeedLoader.Result) -> Void) {
        feedLoader.loadFeed { [weak self] result in
            guard let self else { return }
            
            completion(result
                .map { feed in
                    self.delegate.didPreloadMediaData(for: feed, completion: {})
                    return feed
                })
        }
    }
}
