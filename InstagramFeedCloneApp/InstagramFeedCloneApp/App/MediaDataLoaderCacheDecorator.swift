//
//  MediaDataLoaderCacheDecorator.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 24/04/2025.
//

import Foundation
import InstagramFeedClone

final class MediaDataLoaderCacheDecorator: MediaDataLoader {
    private let decoratee: MediaDataLoader
    private let cache: MediaDataCache
    
    public init(decoratee: MediaDataLoader, cache: MediaDataCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    func loadMediaData(from url: URL, completion: @escaping (MediaDataLoader.Result) -> Void) -> MediaDataLoaderTask {
        return decoratee.loadMediaData(from: url) { [weak self] result in
            completion(result.map { data in
                self?.cache.saveIgnoringResult(data, for: url)
                return data
            })
        }
    }
}

private extension MediaDataCache {
    func saveIgnoringResult(_ data: Data, for url: URL) {
        save(data, for: url) { _ in }
    }
}
