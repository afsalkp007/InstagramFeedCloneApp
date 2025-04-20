//
//  DataStore.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 19/04/2025.
//

import Foundation

public protocol DataStore {
    typealias DeletionResult = Result<Void, Error>
    typealias DeletionCompletion = (DeletionResult) -> Void

    typealias InsertionResult = Result<Void, Error>
    typealias InsertionCompletion = (InsertionResult) -> Void
    
    typealias RetrievalResult = Result<[Post], Error>
    typealias RetrievalCompletion = (RetrievalResult) -> Void
    
    func deleteCachedData(_ completion: @escaping DeletionCompletion)
    
    func insert(_ feed: [Post], completion: @escaping InsertionCompletion)
    
    func retrieve(completion: @escaping RetrievalCompletion)
}

