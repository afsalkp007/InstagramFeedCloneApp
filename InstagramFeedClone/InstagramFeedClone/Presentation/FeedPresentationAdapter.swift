//
//  FeedPresentationAdapter.swift
//  InstagramFeedClone
//
//  Created by Mohamed Afsal on 01/05/2025.
//

import Foundation

public struct ErrorWrapper: Identifiable {
    public let id = UUID()
    public let message: String
}

@Observable
public final class FeedPresentationAdapter {
    public var isLoading: Bool = false
    public var viewModels: [ItemViewModel] = []
    public var errorMessage: ErrorWrapper?
    
    private let viewModel: FeedViewModel
    private let mediaLoader: MediaDataLoader

    public init(viewModel: FeedViewModel, mediaLoader: MediaDataLoader) {
        self.viewModel = viewModel
        self.mediaLoader = mediaLoader
    }
    
    public func loadFeed() {
        bind()
        viewModel.didRequestsFeed()
    }
    
    private func bind() {
        viewModel.onIsLoad = { [weak self] isLoading in
            self?.isLoading = isLoading
        }
        
        viewModel.onLoadFeed = { [weak self] feed in
            self?.viewModels = Self.adapt(feed, mediaLoader: self!.mediaLoader)
        }
        
        viewModel.onLoadError = { [weak self] error in
            self?.errorMessage = ErrorWrapper(message: error.localizedDescription)
        }
    }
    
    private static func adapt(_ feed: [FeedItem], mediaLoader: MediaDataLoader) -> [ItemViewModel] {
        return feed.map { item in
            return ItemViewModel(item: item, loader: mediaLoader)
        }
    }
}
