//
//  FeedPresentationAdapter.swift
//  InstagramFeedClone
//
//  Created by Mohamed Afsal on 01/05/2025.
//

import Foundation
import InstagramFeedClone
import InstagramFeedCloneiOS

final class FeedLoaderPresentationAdapter: FeedViewDelegate {
    
    private let feedLoader: FeedLoader
    private let viewModel: FeedViewModel
    
    init(feedLoader: FeedLoader, viewModel: FeedViewModel) {
        self.feedLoader = feedLoader
        self.viewModel = viewModel
    }
    
    func didRequestsFeed() {
        viewModel.didStartLoadingFeed()

        feedLoader.loadFeed { [weak self] result in
            switch result {
            case let .success(feed):
                self?.viewModel.didFinishLoading(with: feed)
            case let .failure(error):
                self?.viewModel.didFinishLoadingWithError(with: error)
            }
        }
    }
}
