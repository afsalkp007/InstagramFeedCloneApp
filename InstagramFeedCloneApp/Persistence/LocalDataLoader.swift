//
//  CacheManager.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 18/04/2025.
//

import Foundation

final class LocalDataLoader {
    private let store: DataStore
    
    init(store: DataStore) {
        self.store = store
    }
}

extension LocalDataLoader: DataLoader {
    typealias LoadResult = DataLoader.Result
    
    func loadPosts(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { result in
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
    typealias SaveResult = DataSaver.Result
    
    func savePosts(_ posts: [Post], completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedData { [weak self] result in
            switch result {
            case .success:
                self?.store.insert(posts, completion: completion)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
