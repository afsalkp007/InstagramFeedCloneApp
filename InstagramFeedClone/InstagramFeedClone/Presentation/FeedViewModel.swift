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

public protocol FeedPreloadable {
    typealias EmptyCompletion = () -> Void
    
    func didPreloadMediaData(for feed: [FeedItem], completion: @escaping EmptyCompletion)
    func didCancelMediaLoad()
}

@Observable
public class FeedViewModel {
    public var viewModels: [ItemViewModel] = []
    public var errorMessage: ErrorWrapper?
    var isLoading: Bool = false

    private let feedLoader: FeedLoader
    private let mediaLoader: MediaDataLoader

    public init(feedLoader: FeedLoader, mediaLoader: MediaDataLoader) {
        self.feedLoader = feedLoader
        self.mediaLoader = mediaLoader
    }

    public func fetchFeed() {
        isLoading = true

        feedLoader.loadFeed { [weak self] result in
            guard let self else { return }
            self.isLoading = false

            switch result {
            case let .success(feed):
                self.viewModels = feed.map { item in
                    return ItemViewModel(item: item, loader: self.mediaLoader)
                }
            case .failure(let error):
                self.errorMessage = ErrorWrapper(message: error.localizedDescription)
            }
        }
    }
    
    public var showShimmer: Bool {
        isLoading && viewModels.isEmpty
    }
}

extension FeedViewModel {
    public var title: String {
        Localized.title.value
    }
    
    public var error: String {
        Localized.error.value
    }
    
    public var ok: String {
        Localized.ok.value
    }
    
    private enum Localized {
        case title
        case error
        case ok
        
        var value: String {
            switch self {
            case .title:
                return localized(key: "FEED_VIEW_TITLE")
            case .error:
                return localized(key: "FEED_VIEW_ERROR")
            case .ok:
                return localized(key: "FEED_VIEW_OK")
            }
        }
    }
    
    private static func localized(key: String) -> String {
        return NSLocalizedString(
            key,
          tableName: "Item",
          bundle: Bundle(for: FeedViewModel.self),
          comment: ""
        )
    }
}
