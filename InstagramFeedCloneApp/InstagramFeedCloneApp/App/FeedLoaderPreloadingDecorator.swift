//
//  FeedLoaderPreloadingDecorator.swift
//  InstagramFeedClone
//
//  Created by Mohamed Afsal on 30/04/2025.
//

import InstagramFeedClone

final class FeedLoaderPreloadingDecorator: FeedLoader {
    private let decoratee: FeedLoader
    private let preloader: FeedPreloadable
    
    init(feedLoader: FeedLoader, preloader: FeedPreloadable) {
        self.decoratee = feedLoader
        self.preloader = preloader
    }
    
    func loadFeed(completion: @escaping (FeedLoader.Result) -> Void) {
        decoratee.loadFeed { [weak self] result in
            guard let self else { return }
            
            completion(result
                .map { feed in
                    self.preloader.didPreloadMediaData(for: feed)
                    return feed
                })
        }
    }
}
