//
//  DataLoaderWithFallbackComposite.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 18/04/2025.
//

import Foundation
import InstagramFeedClone

public final class RemoteFeedLoaderWithFallbackComposite: FeedLoader {
    private let primary: FeedLoader
    private let fallback: FeedLoader
    
    public init(primary: FeedLoader, fallback: FeedLoader) {
        self.primary = primary
        self.fallback = fallback
    }
    
    public func loadFeed(completion: @escaping (FeedLoader.Result) -> Void) {
        primary.loadFeed { [weak self] result in
            switch result {
            case .success:
                completion(result)
                
            case .failure:
                self?.fallback.loadFeed(completion: completion)
            }
        }
    }
}

