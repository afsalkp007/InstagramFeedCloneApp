//
//  CacheManager.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 18/04/2025.
//

import Foundation

struct LocalDataLoader {
    private let cacheKey = "cachedPosts"
    
    func clearCache() {
        UserDefaults.standard.removeObject(forKey: cacheKey)
    }
}

extension LocalDataLoader: DataLoader {
    func loadPosts(completion: @escaping (DataLoader.Result) -> Void) {
        do {
            guard let data = UserDefaults.standard.data(forKey: cacheKey) else {
                return completion(.success([]))
            }
            let posts = try JSONDecoder().decode([Post].self, from: data)
            completion(.success(posts))
        } catch {
            completion(.failure(error))
        }
    }
}

extension LocalDataLoader: DataSaver {
    func savePosts(_ posts: [Post]) {
        let encoded = try? JSONEncoder().encode(posts)
        UserDefaults.standard.set(encoded, forKey: cacheKey)
    }
}
