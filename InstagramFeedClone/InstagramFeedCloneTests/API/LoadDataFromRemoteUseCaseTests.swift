//
//  RemoteDataLoaderTests.swift
//  InstagramFeedCloneAppTests
//
//  Created by Mohamed Afsal on 19/04/2025.
//

import XCTest
import InstagramFeedClone

final class LoadDataFromRemoteUseCaseTests: XCTestCase {
    
    func test_loadPosts_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        let clientError = anyNSError()
        
        expect(sut, toCompleteWith: .failure(clientError)) {
            client.complete(with: clientError)
        }
    }
    
    func test_loadPosts_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        let samples = [199, 201, 400, 500]
        
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .failure(RemoteFeedLoader.Error.invalidData)) {
                client.complete(withStatusCode: code, data: Data(), at: index)
            }
        }
    }
    
    func test_loadPosts_deliversPostsOn200HTTPResponseWithValidData() {
        let (sut, client) = makeSUT()
        let json = [makePost(id: "1", images: [["id": "1", "type": "image/jpeg", "link": "https://example.com/image1.jpg"]]),
                    makePost(id: "2", images: [["id": "2", "type": "image/png", "link": "https://example.com/image2.png"]])]
        let data = makeValidJSON(posts: json)
        
        let posts = try! RemoteDataItemMapper.map(data, from: HTTPURLResponse(statusCode: 200))
        
        expect(sut, toCompleteWith: .success(posts)) {
            client.complete(withStatusCode: 200, data: data)
        }
    }
    
    func test_loadPosts_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let client = HTTPClientSpy()
        var sut: RemoteFeedLoader? = RemoteFeedLoader(request: URLRequest(url: anyURL()), client: client)
        
        var capturedResults = [RemoteFeedLoader.Result]()
        sut?.loadFeed { capturedResults.append($0) }
        
        sut = nil
        client.complete(withStatusCode: 200, data: Data())
        
        XCTAssertTrue(capturedResults.isEmpty, "Expected no result, but got \(capturedResults)")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let request = URLRequest(url: anyURL())
        let sut = RemoteFeedLoader(request: request, client: client)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }
    
    private func expect(_ sut: RemoteFeedLoader, toCompleteWith expectedResult: RemoteFeedLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.loadFeed { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedPosts), .success(expectedPosts)):
                XCTAssertEqual(receivedPosts, expectedPosts, file: file, line: line)
            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 5.0)
    }
    
    private func makePost(id: String, images: [[String: Any]]) -> [String: Any] {
        return [
            "id": id,
            "images": images
        ]
    }
    
    private func makeValidJSON(posts: [[String: Any]]) -> Data {
        let json: [String: Any] = [
            "status": 200,
            "success": true,
            "data": posts
        ]
        return try! JSONSerialization.data(withJSONObject: json)
    }
}
