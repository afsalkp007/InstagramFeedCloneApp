//
//  RemoteMediaDataLoaderTests.swift
//  InstagramFeedCloneAppTests
//
//  Created by Mohamed Afsal on 20/04/2025.
//

import XCTest
import InstagramFeedCloneApp

final class RemoteMediaDataLoaderTests: XCTestCase {
    
    func test_loadMediaData_requestsDataFromURL() {
        // Arrange
        let url = URL(string: "https://example.com/media")!
        let (sut, httpClient) = makeSUT()
        
        // Act
        sut.loadMediaData(from: url) { _ in }
        
        // Assert	
        XCTAssertEqual(httpClient.requestedURLs, [url])
    }
    
    func test_loadMediaData_deliversErrorOnClientError() {
        // Arrange
        let (sut, httpClient) = makeSUT()
        let url = URL(string: "https://example.com/media")!
        let clientError = NSError(domain: "Test", code: 0)
        
        // Act
        var receivedError: Error?
        sut.loadMediaData(from: url) { result in
            if case let .failure(error) = result {
                receivedError = error
            }
        }
        httpClient.complete(with: clientError)
        
        // Assert
        XCTAssertEqual(receivedError as NSError?, clientError)
    }
    
    func test_loadMediaData_deliversDataOnSuccess() {
        // Arrange
        let (sut, httpClient) = makeSUT()
        let url = URL(string: "https://example.com/media")!
        let expectedData = Data("media data".utf8)
        
        // Act
        var receivedData: Data?
        sut.loadMediaData(from: url) { result in
            if case let .success(data) = result {
                receivedData = data
            }
        }
        httpClient.complete(withStatusCode: 200, data: expectedData)
        
        // Assert
        XCTAssertEqual(receivedData, expectedData)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (RemoteMediaDataLoader, HTTPClientSpy) {
        let httpClient = HTTPClientSpy()
        let sut = RemoteMediaDataLoader(httpClient: httpClient)
        return (sut, httpClient)
    }
}
