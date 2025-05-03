//
//  RemoteFeedLoaderWithFallbackCompositeTests.swift
//  InstagramFeedCloneTests
//
//  Created by Mohamed Afsal on 02/05/2025.
//

import XCTest
import InstagramFeedClone
import InstagramFeedCloneApp

class RemoteFeedLoaderWithFallbackCompositeTests: XCTestCase, FeedLoaderTests {
    
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
    
    private func makeSUT(primaryResult: FeedLoader.Result, fallbackResult: FeedLoader.Result, file: StaticString = #filePath, line: UInt = #line) -> FeedLoader {
        let primaryLoaderStub = FeedLoaderStub(result: primaryResult)
        let fallbackLoaderStub = FeedLoaderStub(result: fallbackResult)
        let sut = RemoteFeedLoaderWithFallbackComposite(primary: primaryLoaderStub, fallback: fallbackLoaderStub)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
