//
//  FeedLoaderCacheDecoratorTests.swift
//  InstagramFeedCloneTests
//
//  Created by Mohamed Afsal on 03/05/2025.
//

import XCTest
import InstagramFeedClone
import InstagramFeedCloneApp

class FeedLoaderCacheDecoratorTests: XCTestCase, FeedLoaderTests {
    
    func test_loadFeed_deliversSuccessWhenLoaderSuccess() {
        let feed = uniqueItems().models
        let sut = makeSUT(.success(feed))
        
        expect(sut, toCompleteWith: .success(feed))
    }
    
    func test_loadFeed_deliversFailureWhenLoaderFailure() {
        let sut = makeSUT(.failure(anyNSError()))
        
        expect(sut, toCompleteWith: .failure(anyNSError()))
    }
    
    func test_loadFeed_CacheDataWhenLoaderSuccess() {
        let feed = uniqueItems().models
        let cache = CacheSpy()
        let sut = makeSUT(.success(feed), cache: cache)
        
        sut.loadFeed { _ in }
        
        XCTAssertEqual(cache.messages, [.save(feed)])
    }
    
    func test_loadFeed_DoesNotCacheDataWhenLoaderFailure() {
        let cache = CacheSpy()
        let sut = makeSUT(.failure(anyNSError()), cache: cache)
        
        sut.loadFeed { _ in }
        
        XCTAssertTrue(cache.messages.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(_ result: FeedLoader.Result, cache: CacheSpy = .init(), file: StaticString = #filePath, line: UInt = #line) -> FeedLoader {
        let loader = FeedLoaderStub(result: result)
        let sut = FeedLoaderCacheDecorator(decoratee: loader, cache: cache)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        return sut
    }
        
    private class CacheSpy: FeedCache {
        enum Message: Equatable {
            case save([FeedItem])
        }
        
        var messages: [Message] = []
        
        func saveFeed(_ feed: [FeedItem], completion: @escaping (FeedCache.Result) -> Void) {
            messages.append(.save(feed))
        }
    }
}
