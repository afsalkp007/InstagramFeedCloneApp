//
//  UserDefaultsDataStore.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 19/04/2025.
//

import Foundation

public final class UserDefaultsFeedStore: FeedStore {
    private let userDefaults: UserDefaults
    private let key = Constants.Cache.key.value
    
    public init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    public func deleteCachedData(_ completion: @escaping DeletionCompletion) {
        userDefaults.removeObject(forKey: key)
        completion(.success(()))
    }

    public func insert(_ feed: [Post], completion: @escaping InsertionCompletion) {
        do {
            let data = try JSONEncoder().encode(feed)
            userDefaults.set(data, forKey: key)
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    private struct DataNotFoundError: Error {}
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        guard let data = userDefaults.data(forKey: key) else {
            completion(.failure(DataNotFoundError()))
            return
        }
        
        do {
            let feed = try JSONDecoder().decode([Post].self, from: data)
            completion(.success(feed))
        } catch {
            completion(.failure(error))
        }
    }
}
