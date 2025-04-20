//
//  DataStoreSpy.swift
//  InstagramFeedCloneAppTests
//
//  Created by Mohamed Afsal on 19/04/2025.
//

import InstagramFeedClone

class DataStoreSpy: DataStore {
    enum Message: Equatable {
        case retrieve
        case deleteCachedData
        case insert([Post])
    }

    private(set) var receivedMessages = [Message]()
    private var retrievalCompletions = [(Result<[Post], Error>) -> Void]()
    private var deletionCompletions = [(Result<Void, Error>) -> Void]()
    private var insertionCompletions = [(Result<Void, Error>) -> Void]()

    func retrieve(completion: @escaping (Result<[Post], Error>) -> Void) {
        receivedMessages.append(.retrieve)
        retrievalCompletions.append(completion)
    }

    func deleteCachedData(_ completion: @escaping (Result<Void, Error>) -> Void) {
        receivedMessages.append(.deleteCachedData)
        deletionCompletions.append(completion)
    }

    func insert(_ posts: [Post], completion: @escaping (Result<Void, Error>) -> Void) {
        receivedMessages.append(.insert(posts))
        insertionCompletions.append(completion)
    }

    func completeRetrieval(with posts: [Post], at index: Int = 0) {
        retrievalCompletions[index](.success(posts))
    }

    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](.failure(error))
    }

    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](.success(()))
    }

    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionCompletions[index](.failure(error))
    }

    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompletions[index](.success(()))
    }

    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionCompletions[index](.failure(error))
    }
}
