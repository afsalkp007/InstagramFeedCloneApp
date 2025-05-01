//
//  FeedViewModel.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 17/04/2025.
//

import Foundation

public struct ErrorWrapper: Identifiable {
    public let id = UUID()
    public let message: String
}

@Observable
public class FeedViewModel {
    public var viewModels: [ItemViewModel] = []
    public var errorMessage: ErrorWrapper?
    var isLoading: Bool = false

    private let mediaLoader: MediaDataLoader

    public init(mediaLoader: MediaDataLoader) {
        self.mediaLoader = mediaLoader
    }
    
    public func didStartLoadingFeed() {
        isLoading = true
    }
    
    public func didFinishLoading(with feed: [FeedItem]) {
        isLoading = false
        viewModels = ItemViewModelAdapter.adapt(feed, mediaLoader: mediaLoader)
    }
    
    public func didFinishLoadingWithError(with error: Error) {
        isLoading = false
        errorMessage = ErrorWrapper(message: error.localizedDescription)
    }
    
    public var showShimmer: Bool {
        isLoading && viewModels.isEmpty
    }
}

final class ItemViewModelAdapter {
    static func adapt(_ feed: [FeedItem], mediaLoader: MediaDataLoader) -> [ItemViewModel] {
        return feed.map { item in
            return ItemViewModel(item: item, loader: mediaLoader)
        }
    }
}
    
    
