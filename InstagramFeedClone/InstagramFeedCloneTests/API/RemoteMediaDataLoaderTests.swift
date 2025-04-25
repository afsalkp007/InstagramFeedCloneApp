//
//  RemoteMediaDataLoaderTests.swift
//  InstagramFeedCloneAppTests
//
//  Created by Mohamed Afsal on 20/04/2025.
//

import XCTest
import InstagramFeedClone

final class RemoteMediaDataLoaderTests: XCTestCase {
    
    func test_loadMediaData_requestsDataFromURL() {
        let url = anyURL()
        let (sut, client) = makeSUT()
        
        _ = sut.loadMediaData(from: url) { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadMediaData_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        let clientError = anyNSError()
        
        expect(sut, toCompleteWith: failure(.connectivity), when: {
            client.complete(with: clientError)
        })
    }
    
    func test_loadMediaData_deliversDataOnSuccess() {
        let (sut, client) = makeSUT()
        let expectedData = Data("media data".utf8)
        
        expect(sut, toCompleteWith: .success(expectedData), when: {
            client.complete(withStatusCode: 200, data: expectedData)
        })
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (MediaDataLoader, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteMediaDataLoader(client: client)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }
    
    private func failure(_ error: RemoteMediaDataLoader.Error) -> RemoteMediaDataLoader.Result {
        return .failure(error)
    }
    
    private func expect(_ sut: MediaDataLoader, toCompleteWith expectedResult: MediaDataLoader.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
      let url = URL(string: "https://a-given-url.com")!
      
      let exp = expectation(description: "Wait for load completion")
      
      _ = sut.loadMediaData(from: url) { receivedResult in
        switch (receivedResult, expectedResult) {
        case let (.success(receivedData), .success(expectedData)):
          XCTAssertEqual(receivedData, expectedData, file: file, line: line)
          
        case let (.failure(receivedError as RemoteMediaDataLoader.Error), .failure(expectedError as RemoteMediaDataLoader.Error)):
          XCTAssertEqual(receivedError, expectedError, file: file, line: line)
          
        default:
          XCTFail("Expected \(expectedResult), got \(receivedResult) instead.", file: file, line: line)
        }
        
        exp.fulfill()
      }
      
      action()
      
      wait(for: [exp], timeout: 1.0)
    }
}
