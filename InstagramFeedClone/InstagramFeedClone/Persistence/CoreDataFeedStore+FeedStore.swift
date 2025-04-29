//
//  CoreDataFeedStore+FeedStore.swift
//  InstagramFeedClone
//
//  Created by Mohamed Afsal on 29/04/2025.
//

import Foundation

extension CoreDataFeedStore: FeedStore {
    public func deleteCachedData(_ completion: @escaping DeletionCompletion) {
        perform { context in
            completion(Result {
                try ManagedCache.find(in: context).map(context.delete).map(context.save)
            })
        }
    }
    
    public func insert(_ feed: [LocalFeedItem], completion: @escaping InsertionCompletion) {
        perform { context in
            completion(Result {
                let managedCache = try ManagedCache.newUniqueInstance(in: context)
                managedCache.feed = ManagedFeedItem.images(from: feed, in: context)
                try context.save()
            })
        }
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        perform { context in
            completion(Result {
                try ManagedCache.find(in: context).map { $0.localFeed }
            })
        }
    }
}
