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
    public var viewModels: [PostViewModel] = []
    public var errorMessage: ErrorWrapper?
    var isLoading: Bool = false

    private let feedLoader: DataLoader
    private let mediaPreloader: MediaPreloader

    public init(feedLoader: DataLoader, mediaLoader: MediaDataLoader) {
        self.feedLoader = feedLoader
        self.mediaPreloader = MediaPreloader(
            cacheManager: CacheManager(),
            mediaLoader: mediaLoader
        )
    }
    
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
          tableName: "Post",
          bundle: Bundle(for: FeedViewModel.self),
          comment: ""
        )
    }

    public func fetchPosts() {
        isLoading = true

        feedLoader.loadPosts { [weak self] result in
            guard let self else { return }
            self.isLoading = false

            switch result {
            case let .success(posts):
                self.viewModels = self.getPostViewModels(from: posts)
                self.preloadMedia(for: posts)
            case .failure(let error):
                self.errorMessage = ErrorWrapper(message: error.localizedDescription)
            }
        }
    }

    private func getPostViewModels(from posts: [Post]) -> [PostViewModel] {
        posts.map { post in
            let media = post.images?.first ?? placeHolderMedia
            return PostViewModel(media: media, loader: mediaPreloader.mediaLoader)
        }
    }
    
    private func preloadMedia(for posts: [Post]) {
        let mediaURLs = posts.compactMap { $0.images?.first?.link }.compactMap { URL(string: $0) }
        mediaPreloader.preloadMedia(urls: mediaURLs) {
            self.isLoading = false
        }
    }

    private var placeHolderMedia: Media {
        Media(
            id: "dfsd3423",
            type: .imageJPEG,
            link: "https://i.imgur.com/foheRIC.jpg"
        )
    }

    public var showShimmer: Bool {
        isLoading && viewModels.isEmpty
    }
}
