//
//  TestHelpers.swift
//  InstagramFeedCloneAppTests
//
//  Created by Mohamed Afsal on 19/04/2025.
//

import XCTest

extension XCTest {
    func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }
    
    func anyURL() -> URL {
        return URL(string: "https://example.com")!
    }
    
    func anyData() -> Data {
        return Data("any data".utf8)
    }
}
