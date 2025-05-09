//
//  Expect+XCTest.swift
//  InstagramFeedCloneAppTests
//
//  Created by Mohamed Afsal on 03/05/2025.
//

import XCTest
import InstagramFeedClone

protocol FeedLoaderTests: XCTestCase {}

extension FeedLoaderTests {
    func expect(_ sut: FeedLoader, toCompleteWith expectedResult: FeedLoader.Result, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.loadFeed { receivedResult in
            switch (expectedResult, receivedResult) {
            case let (.success(expectedFeed), .success(receivedFeed)):
                XCTAssertEqual(expectedFeed, receivedFeed, file: file, line: line)
            case let (.failure(expectedError as NSError), .failure(receivedError as NSError)):
                XCTAssertEqual(expectedError, receivedError, file: file, line: line)
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult).")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.1)
    }
}
