//
//  DataStoreSpy.swift
//  InstagramFeedCloneAppTests
//
//  Created by Mohamed Afsal on 19/04/2025.
//

import InstagramFeedClone

final class FeedStoreSpy: FeedStore {
    enum Message: Equatable {
        case retrieve
        case deleteCachedData
        case insert([LocalFeedItem])
    }

    private(set) var receivedMessages = [Message]()
    private var retrievalCompletions = [(Result<[LocalFeedItem]?, Error>) -> Void]()
    private var deletionCompletions = [(Result<Void, Error>) -> Void]()
    private var insertionCompletions = [(Result<Void, Error>) -> Void]()

    func retrieve(completion: @escaping (Result<[LocalFeedItem]?, Error>) -> Void) {
        receivedMessages.append(.retrieve)
        retrievalCompletions.append(completion)
    }

    func deleteCachedData(_ completion: @escaping (Result<Void, Error>) -> Void) {
        receivedMessages.append(.deleteCachedData)
        deletionCompletions.append(completion)
    }

    func insert(_ feed: [LocalFeedItem], completion: @escaping (Result<Void, Error>) -> Void) {
        receivedMessages.append(.insert(feed))
        insertionCompletions.append(completion)
    }

    func completeRetrieval(with feed: [LocalFeedItem], at index: Int = 0) {
        retrievalCompletions[index](.success(feed))
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
