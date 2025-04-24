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
        let baseURL = anyURL()
        let page = 1
        let endpoint = PostEndPoint.getPosts(page: page)
        
        // Act
        let url = endpoint.url(baseURL: baseURL)
        
        // Assert
        XCTAssertEqual(url.absoluteString, "https://example.com/3/gallery/hot/viral/day/1")
    }
}
