//
//  RemoteMediaDataLoaderWithFallbackComposite.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 24/04/2025.
//

import Foundation
import InstagramFeedClone

final class RemoteMediaDataLoaderWithFallbackComposite: MediaDataLoader {
   
    private let primary: MediaDataLoader
    private let fallback: MediaDataLoader
        
    public init(primary: MediaDataLoader, fallback: MediaDataLoader) {
        self.primary = primary
        self.fallback = fallback
    }
    
    private class TaskWrapper: MediaDataLoaderTask {
        var wrapped: MediaDataLoaderTask?
        
        func cancel() {
            wrapped?.cancel()
        }
    }
    
    public func loadMediaData(from url: URL, completion: @escaping (MediaDataLoader.Result) -> Void) -> MediaDataLoaderTask {
        let task = TaskWrapper()
        task.wrapped = primary.loadMediaData(from: url) { [weak self] result in
            switch result {
            case .success:
                completion(result)
                
            case .failure:
                task.wrapped = self?.fallback.loadMediaData(from: url, completion: completion)
            }
        }
        return task
    }
}

