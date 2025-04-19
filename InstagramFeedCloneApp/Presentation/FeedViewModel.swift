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
    private let mediaLoader: MediaDataLoader
    private var cacheManager: CacheManager

    init(feedLoader: DataLoader, mediaLoader: MediaDataLoader) {
        self.feedLoader = feedLoader
        self.mediaLoader = mediaLoader
        self.cacheManager = CacheManager()
    }
    
    func fetchPosts() {
        isLoading = true
        
        feedLoader.loadPosts { [weak self] result in
            guard let self else { return }
            self.isLoading = false
            
            switch result {
            case let .success(posts):
                self.cacheManager.clearCache()
                self.viewModels = self.getPostViewModels(from: posts)
                self.preloadMedia(for: posts)
            case .failure(let error):
                self.errorMessage = ErrorWrapper(message: error.localizedDescription)
            }
        }
    }
    
    private func getMedia(for post: Post) -> Media {
        guard let media = post.images?.first else { return placeHolderMedia }
        return media
    }
    
    private func getPostViewModels(from posts: [Post]) -> [PostViewModel] {
        posts.map { post in
            let media = getMedia(for: post)
            return PostViewModel(media: media, loader: mediaLoader)
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
    
    // MARK: - Preload
    
    private func preloadMedia(for posts: [Post]) {
        let mediaURLs = posts.compactMap { $0.images?.first?.link }.compactMap { URL(string: $0) }
        preloadData(urls: mediaURLs) {
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }

    typealias PreLoadCompletion = (() -> Void)?

    private func preloadData(urls: [URL], completion: PreLoadCompletion) {
        let dispatchGroup = DispatchGroup()

        for url in urls {
            dispatchGroup.enter()
            cacheManager.getCachedData(for: url) { [weak self] cachedData in
                if cachedData == nil {
                    self?.preloadMedia(for: url) {
                        dispatchGroup.leave()
                    }
                } else {
                    dispatchGroup.leave()
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            completion?()
        }
    }
    
    private typealias EmptyClosure = () -> Void
    
    private func preloadMedia(for url: URL, completion: @escaping EmptyClosure) {
        mediaLoader.loadMediaData(from: url) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(data):
                self.cacheManager.cacheData(data, for: url)
            case .failure:
                break
            }
            completion()
        }
    }
}
