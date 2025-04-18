//
//  UserDefaultsDataStore.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 19/04/2025.
//

import Foundation

final class UserDefaultsDataStore: DataStore {
    private let userDefaults: UserDefaults
    private let key: String
    
    init(userDefaults: UserDefaults = .standard, key: String) {
        self.userDefaults = userDefaults
        self.key = key
    }
    
    func deleteCachedData(_ completion: @escaping DeletionCompletion) {
        userDefaults.removeObject(forKey: key)
        completion(.success(()))
    }

    func insert(_ feed: [Post], completion: @escaping InsertionCompletion) {
        do {
            let data = try JSONEncoder().encode(feed)
            userDefaults.set(data, forKey: key)
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    private struct DataNotFoundError: Error {}
    
    func retrieve(completion: @escaping RetrievalCompletion) {
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
