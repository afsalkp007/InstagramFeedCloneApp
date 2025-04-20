//
//  FeedViewModel.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 17/04/2025.
//

import Foundation

struct ErrorWrapper: Identifiable {
    let id = UUID()
    let message: String
}

@Observable
class FeedViewModel {
    var viewModels: [PostViewModel] = []
    var errorMessage: ErrorWrapper?
    var isLoading: Bool = false

    private let feedLoader: DataLoader
    private let mediaPreloader: MediaPreloader

    init(feedLoader: DataLoader, mediaLoader: MediaDataLoader) {
        self.feedLoader = feedLoader
        self.mediaPreloader = MediaPreloader(
            cacheManager: CacheManager(),
            mediaLoader: mediaLoader
        )
    }

    func fetchPosts() {
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
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }

    private var placeHolderMedia: Media {
        Media(
            id: "dfsd3423",
            type: .imageJPEG,
            link: "https://i.imgur.com/foheRIC.jpg"
        )
    }

    var showShimmer: Bool {
        isLoading && viewModels.isEmpty
    }
}
