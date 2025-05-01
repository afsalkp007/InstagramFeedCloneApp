//
//  CoreDataFeedStore+MediaDataStore.swift
//  InstagramFeedClone
//
//  Created by Mohamed Afsal on 29/04/2025.
//

import Foundation

extension CoreDataFeedStore: MediaDataStore {
  public func insert(_ data: Data, for url: URL, completion: @escaping (MediaDataStore.InsertionResult) -> Void) {
    perform { context in
      completion(Result {
          try ManagedFeedItem.first(with: url, in: context)
          .map { $0.data = data }
          .map(context.save)
      })
    }
  }
  
  public func retrieve(dataForURL url: URL, completion: @escaping (MediaDataStore.RetrievalResult) -> Void) {
    perform { context in
      completion(Result {
        try ManagedFeedItem.first(with: url, in: context)?.data
      })
    }
  }
}
