//
//  CacheDataUseCaseTests.swift
//  InstagramFeedCloneAppTests
//
//  Created by Mohamed Afsal on 19/04/2025.
//

import XCTest
import InstagramFeedClone


class CacheDataUseCaseTests: XCTestCase {
    
    func test_savePosts_requestsCacheDeletion() {
        let (sut, store) = makeSUT()
        let posts = [makePost(id: "1"), makePost(id: "2")]

        sut.savePosts(posts) { _ in }

        XCTAssertEqual(store.receivedMessages, [.deleteCachedData])
    }

    func test_savePosts_requestsInsertionOnSuccessfulDeletion() {
        let (sut, store) = makeSUT()
        let posts = [makePost(id: "1"), makePost(id: "2")]

        sut.savePosts(posts) { _ in }
        store.completeDeletionSuccessfully()

        XCTAssertEqual(store.receivedMessages, [.deleteCachedData, .insert(posts)])
    }

    func test_savePosts_failsOnDeletionError() {
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()

        expect(sut, toCompleteSaveWith: .failure(deletionError), when: {
            store.completeDeletion(with: deletionError)
        })
    }

    func test_savePosts_failsOnInsertionError() {
        let (sut, store) = makeSUT()
        let insertionError = anyNSError()

        expect(sut, toCompleteSaveWith: .failure(insertionError), when: {
            store.completeDeletionSuccessfully()
            store.completeInsertion(with: insertionError)
        })
    }

    func test_savePosts_succeedsOnSuccessfulInsertion() {
        let (sut, store) = makeSUT()

        expect(sut, toCompleteSaveWith: .success(()), when: {
            store.completeDeletionSuccessfully()
            store.completeInsertionSuccessfully()
        })
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalDataLoader, store: DataStoreSpy) {
        let store = DataStoreSpy()
        let sut = LocalDataLoader(store: store)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(_ sut: LocalDataLoader, toCompleteSaveWith expectedResult: LocalDataLoader.SaveResult, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for save completion")

        sut.savePosts([makePost(id: "1")]) { receivedResult in
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
    
    private func makePost(id: String) -> Post {
        return Post(id: id, images: [])
    }
}

