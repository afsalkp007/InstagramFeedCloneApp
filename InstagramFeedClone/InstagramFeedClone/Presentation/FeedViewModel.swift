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
    private var tasks: [URL: MediaDataLoaderTask] = [:]

    private let feedLoader: FeedLoader
    private let mediaLoader: MediaDataLoader

    public init(feedLoader: FeedLoader, mediaLoader: MediaDataLoader) {
        self.feedLoader = feedLoader
        self.mediaLoader = mediaLoader
    }

    public func fetchPosts() {
        isLoading = true

        feedLoader.loadFeed { [weak self] result in
            guard let self else { return }
            self.isLoading = false

            switch result {
            case let .success(posts):
                self.viewModels = posts.map { post in
                    let media = post.images?.first ?? self.placeHolderMedia
                    return PostViewModel(
                        media: media,
                        loader: self.mediaLoader)
                }
                self.preloadMedia(for: posts)
            case .failure(let error):
                self.errorMessage = ErrorWrapper(message: error.localizedDescription)
            }
        }
    }
    
    public func cancelMediaLoad() {
        tasks.values.forEach { $0.cancel() }
        tasks.removeAll()
    }
}

extension FeedViewModel {
    private func preloadMedia(for posts: [Post]) {
        let mediaURLs = posts.compactMap { $0.images?.first?.link }.compactMap { URL(string: $0) }
        preloadMedia(urls: mediaURLs) { [weak self] in
            self?.isLoading = false
        }
    }

    func preloadMedia(urls: [URL], completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()

        for url in urls {
            dispatchGroup.enter()
                        
            tasks[url] = mediaLoader.loadMediaData(from: url) { result in
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
}

extension FeedViewModel {
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
          tableName: "Post",
          bundle: Bundle(for: FeedViewModel.self),
          comment: ""
        )
    }
}
