//
//  FeedLoaderPreloadingDecorator.swift
//  InstagramFeedClone
//
//  Created by Mohamed Afsal on 30/04/2025.
//

import InstagramFeedClone

final class FeedLoaderPreloadingDecorator: FeedLoader {
    private let decoratee: FeedLoader
    private let delegate: FeedPreloadable
    
    init(feedLoader: FeedLoader, delegate: FeedPreloadable) {
        self.decoratee = feedLoader
        self.delegate = delegate
    }
    
    func loadFeed(completion: @escaping (FeedLoader.Result) -> Void) {
        decoratee.loadFeed { [weak self] result in
            guard let self else { return }
            
            completion(result
                .map { feed in
                    self.delegate.didPreloadMediaData(for: feed)
                    return feed
                })
        }
    }
}
