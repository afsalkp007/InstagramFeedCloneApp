//
//  CacheFeedUseCaseTests.swift
//  InstagramFeedCloneAppTests
//
//  Created by Mohamed Afsal on 19/04/2025.
//

import XCTest
import InstagramFeedClone

class CacheFeedUseCaseTests: XCTestCase {
    
    func test_saveFeed_requestsCacheDeletion() {
        let (sut, store) = makeSUT()

        sut.saveFeed(uniqueItems().models) { _ in }

        XCTAssertEqual(store.receivedMessages, [.deleteCachedData])
    }

    func test_saveFeed_requestsInsertionOnSuccessfulDeletion() {
        let (sut, store) = makeSUT()
        let feed = uniqueItems()

        sut.saveFeed(uniqueItems().models) { _ in }
        store.completeDeletionSuccessfully()

        XCTAssertEqual(store.receivedMessages, [.deleteCachedData, .insert(feed.local)])
    }

    func test_saveFeed_failsOnDeletionError() {
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()

        expect(sut, toCompleteSaveWith: failure(.deletionError), when: {
            store.completeDeletion(with: deletionError)
        })
    }

    func test_saveFeed_failsOnInsertionError() {
        let (sut, store) = makeSUT()
        let insertionError = anyNSError()

        expect(sut, toCompleteSaveWith: .failure(insertionError), when: {
            store.completeDeletionSuccessfully()
            store.completeInsertion(with: insertionError)
        })
    }

    func test_saveFeed_succeedsOnSuccessfulInsertion() {
        let (sut, store) = makeSUT()

        expect(sut, toCompleteSaveWith: .success(()), when: {
            store.completeDeletionSuccessfully()
            store.completeInsertionSuccessfully()
        })
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        return (sut, store)
    }
    
    private func failure(_ error: LocalFeedLoader.Error) -> LocalFeedLoader.SaveResult {
        return .failure(error)
    }
    
    private func expect(_ sut: LocalFeedLoader, toCompleteSaveWith expectedResult: LocalFeedLoader.SaveResult, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for save completion")

        sut.saveFeed(uniqueItems().models) { receivedResult in
            switch (receivedResult, expectedResult) {
            case (.success, .success):
                break

            case let (.failure(receivedError), .failure(expectedError)):
                XCTAssertEqual(receivedError as NSError, expectedError as NSError, file: file, line: line)

            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }

        action()
        wait(for: [exp], timeout: 1.0)
    }
}

