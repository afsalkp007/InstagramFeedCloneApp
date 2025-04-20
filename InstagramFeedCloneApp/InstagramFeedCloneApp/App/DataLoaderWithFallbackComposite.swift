//
//  DataLoaderWithFallbackComposite.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 18/04/2025.
//

import Foundation
import InstagramFeedClone

final class DataLoaderWithFallbackComposite: DataLoader {
    private let primary: DataLoader
    private let fallback: DataLoader
    
    init(primary: DataLoader, fallback: DataLoader) {
        self.primary = primary
        self.fallback = fallback
    }
    
    func loadPosts(completion: @escaping (DataLoader.Result) -> Void) {
        primary.loadPosts { [weak self] result in
            switch result {
            case .success:
                completion(result)
                
            case .failure:
                self?.fallback.loadPosts(completion: completion)
            }
        }
    }
}

