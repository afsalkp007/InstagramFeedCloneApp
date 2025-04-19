//
//  LocalDataLoaderTests.swift
//  InstagramFeedCloneAppTests
//
//  Created by Mohamed Afsal on 19/04/2025.
//

import XCTest
import InstagramFeedCloneApp

final class LocalDataLoaderTests: XCTestCase {

    func test_loadPosts_requestsCacheRetrieval() {
        let (sut, store) = makeSUT()

        sut.loadPosts { _ in }

        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }

    func test_loadPosts_deliversPostsOnSuccessfulRetrieval() {
        let (sut, store) = makeSUT()
        let posts = [makePost(id: "1"), makePost(id: "2")]

        expect(sut, toCompleteWith: .success(posts), when: {
            store.completeRetrieval(with: posts)
        })
    }

    func test_loadPosts_deliversErrorOnRetrievalFailure() {
        let (sut, store) = makeSUT()
        let retrievalError = anyNSError()

        expect(sut, toCompleteWith: .failure(retrievalError), when: {
            store.completeRetrieval(with: retrievalError)
        })
    }

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
    
    private func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }

    private func expect(_ sut: LocalDataLoader, toCompleteWith expectedResult: LocalDataLoader.LoadResult, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")

        sut.loadPosts { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedPosts), .success(expectedPosts)):
                XCTAssertEqual(receivedPosts, expectedPosts, file: file, line: line)

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

    private func expect(_ sut: LocalDataLoader, toCompleteSaveWith expectedResult: Result<Void, Error>, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
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

    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }
}
