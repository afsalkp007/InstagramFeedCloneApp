//
//  MediaPreloader.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 20/04/2025.
//

import Foundation

class MediaPreloader {
    private let cacheManager: CacheManager
    let mediaLoader: MediaDataLoader

    init(cacheManager: CacheManager, mediaLoader: MediaDataLoader) {
        self.cacheManager = cacheManager
        self.mediaLoader = mediaLoader
    }

    func preloadMedia(urls: [URL], completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()

        for url in urls {
            dispatchGroup.enter()
            cacheManager.getCachedData(for: url) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success:
                    dispatchGroup.leave()
                case .failure:
                    self.loadMedia(for: url) {
                        dispatchGroup.leave()
                    }
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }

    private func loadMedia(for url: URL, completion: @escaping () -> Void) {
        mediaLoader.loadMediaData(from: url) { [weak self] result in
            guard let self = self else { return }
            
            if case let .success(data) = result {
                self.cacheManager.cacheData(data, for: url)
            }
            completion()
        }
    }
}
