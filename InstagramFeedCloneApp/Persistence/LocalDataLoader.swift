//
//  CacheManager.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 18/04/2025.
//

import Foundation

public final class LocalDataLoader {
    private let store: DataStore
    
    public init(store: DataStore) {
        self.store = store
    }
}

extension LocalDataLoader: DataLoader {
    public typealias LoadResult = DataLoader.Result
    
    public func loadPosts(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success(posts):
                completion(.success(posts))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

extension LocalDataLoader: DataSaver {
    public typealias SaveResult = DataSaver.Result
    
    public func savePosts(_ posts: [Post], completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedData { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                self.store.insert(posts, completion: completion)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
