//
//  PostEndPointTests.swift
//  InstagramFeedCloneAppTests
//
//  Created by Mohamed Afsal on 20/04/2025.
//

import XCTest

import InstagramFeedClone

final class PostEndPointTests: XCTestCase {

    func testGetPostsURL() {
        // Arrange
        let baseURL = URL(string: "https://base-url.com")!
        let page = 1
        let endpoint = PostEndPoint.getPosts(page: page)
        
        // Act
        let received = endpoint.url(baseURL: baseURL)
        
        // Assert
        XCTAssertEqual(received.scheme, "https", "scheme")
        XCTAssertEqual(received.host, "base-url.com", "host")
        XCTAssertEqual(received.path, "/3/gallery/hot/viral/day/1", "path")
        XCTAssertEqual(received.absoluteString, "https://base-url.com/3/gallery/hot/viral/day/1")
    }
}
