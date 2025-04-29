//
//  LocalDataLoaderTests.swift
//  InstagramFeedCloneAppTests
//
//  Created by Mohamed Afsal on 19/04/2025.
//

import XCTest
import InstagramFeedClone

final class LoadDataFromCacheUseCaseTests: XCTestCase {

    func test_loadFeed_requestsCacheRetrieval() {
        let (sut, store) = makeSUT()

        sut.loadFeed { _ in }

        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }

    func test_loadFeed_deliversFeedOnSuccessfulRetrieval() {
        let (sut, store) = makeSUT()
        let feed = uniqueItems()

        expect(sut, toCompleteWith: .success(feed.models), when: {
            store.completeRetrieval(with: feed.local)
        })
    }

    func test_loadFeed_deliversErrorOnRetrievalFailure() {
        let (sut, store) = makeSUT()
        let retrievalError = anyNSError()

        expect(sut, toCompleteWith: failure(.loadError), when: {
            store.completeRetrieval(with: retrievalError)
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
    
    private func failure(_ error: LocalFeedLoader.Error) -> LocalFeedLoader.LoadResult {
        return .failure(error)
    }
    
    private func expect(_ sut: LocalFeedLoader, toCompleteWith expectedResult: LocalFeedLoader.LoadResult, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")

        sut.loadFeed { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedFeed), .success(expectedFeed)):
                XCTAssertEqual(receivedFeed, expectedFeed, file: file, line: line)

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
