//
//  FeedViewModel.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 17/04/2025.
//

import Foundation

public class FeedViewModel {
    typealias Observer<T> = (T) -> Void
    
    private let feedLoader: FeedLoader

    public init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    var onIsLoad: Observer<Bool>?
    var onLoadFeed: Observer<[FeedItem]>?
    var onLoadError: Observer<Error>?
        
    func didRequestsFeed() {
        onIsLoad?(true)

        feedLoader.loadFeed { [weak self] result in
            self?.onIsLoad?(false)
            
            switch result {
            case let .success(feed):
                self?.onLoadFeed?(feed)
            case let .failure(error):
                self?.onLoadError?(error)
            }
        }
    }
}    
