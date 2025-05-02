//
//  RemoteFeedLoaderWithFallbackCompositeTests.swift
//  InstagramFeedCloneTests
//
//  Created by Mohamed Afsal on 02/05/2025.
//

import XCTest
import InstagramFeedClone
import InstagramFeedCloneApp

class RemoteFeedLoaderWithFallbackCompositeTests: XCTestCase {
    
    func test_loadFeed_deliversPrimaryFeedOnPrimaryLoaderSuccess() {
        let primaryFeed = uniqueItems().models
        let fallbackFeed = uniqueItems().models
        let sut = makeSUT(primaryResult: .success(primaryFeed), fallbackResult: .success(fallbackFeed))
        
        expect(sut, toCompleteWith: .success(primaryFeed))
    }
    
    func test_loadFeed_deliversFallbackFeedOnPrimaryFailure() {
        let fallbackFeed = uniqueItems().models
        let sut = makeSUT(primaryResult: .failure(anyNSError()), fallbackResult: .success(fallbackFeed))
        
        expect(sut, toCompleteWith: .success(fallbackFeed))
    }
    
    func test_loadFeed_deliversErrorWhenBothPrimaryAndFallbackFailure() {
        let sut = makeSUT(primaryResult: .failure(anyNSError()), fallbackResult: .failure(anyNSError()))
        
        expect(sut, toCompleteWith: .failure(anyNSError()))
    }
    
    // MARK: - Helpers
    
    private func expect(_ sut: FeedLoader, toCompleteWith expectedResult: FeedLoader.Result, file: StaticString = #filePath, line: UInt = #line) {
        
        let exp = expectation(description: "Wait for completion")
        
        sut.loadFeed { receivedResult in
            switch (expectedResult, receivedResult) {
            case let (.success(expecedFeed), .success(receivedFeed)):
                XCTAssertEqual(expecedFeed, receivedFeed, file: file, line: line)
            case let (.failure(expectedError as NSError), .failure(receivedError as NSError)):
                XCTAssertEqual(expectedError, receivedError)
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead.")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func makeSUT(primaryResult: FeedLoader.Result, fallbackResult: FeedLoader.Result, file: StaticString = #filePath, line: UInt = #line) -> FeedLoader {
        let primaryLoaderStub = PrimaryLoaderStub(result: primaryResult)
        let fallbackLoaderStub = PrimaryLoaderStub(result: fallbackResult)
        let sut = RemoteFeedLoaderWithFallbackComposite(primary: primaryLoaderStub, fallback: fallbackLoaderStub)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private struct PrimaryLoaderStub: FeedLoader {
        let result: FeedLoader.Result
        
        func loadFeed(completion: @escaping (FeedLoader.Result) -> Void) {
            completion(result)
        }
    }
    
    private func uniqueItem() -> FeedItem {
        return FeedItem(type: .imagePNG, url: anyURL())
    }

    private func uniqueItems() -> (models: [FeedItem], local: [LocalFeedItem]) {
        let feed = [uniqueItem()]
        let local = feed.map { LocalFeedItem(type: $0.type, url: $0.url) }
        return (feed, local)
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }
    
    private func anyURL() -> URL {
        return URL(string: "https://example.com")!
    }
    
    private func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
