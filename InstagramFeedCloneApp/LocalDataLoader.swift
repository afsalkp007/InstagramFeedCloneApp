//
//  CacheManager.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 18/04/2025.
//

import Foundation

final class LocalDataLoader {
    private let cacheKey = "cachedPosts"
    
    func clearCache() {
        UserDefaults.standard.removeObject(forKey: cacheKey)
    }
}

extension LocalDataLoader: DataLoader {
    func loadPosts(completion: @escaping (DataLoader.Result) -> Void) {
        completion(DataLoader.Result {
            guard let data = UserDefaults.standard.data(forKey: cacheKey) else {
                return []
            }
            let posts = try JSONDecoder().decode([Post].self, from: data)
            return posts
        })
    }
}

extension LocalDataLoader: DataSaver {
    func savePosts(_ posts: [Post]) {
        let encoded = try? JSONEncoder().encode(posts)
        UserDefaults.standard.set(encoded, forKey: cacheKey)
    }
}
