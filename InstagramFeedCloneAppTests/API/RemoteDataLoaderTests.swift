//
//  RemoteDataLoaderTests.swift
//  InstagramFeedCloneAppTests
//
//  Created by Mohamed Afsal on 19/04/2025.
//

import XCTest
import InstagramFeedCloneApp

final class RemoteDataLoaderTests: XCTestCase {
    
    func test_loadPosts_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        let clientError = NSError(domain: "Test", code: 0)
        
        expect(sut, toCompleteWith: .failure(clientError)) {
            client.complete(with: clientError)
        }
    }
    
    func test_loadPosts_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        let samples = [199, 201, 400, 500]
        
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .failure(RemoteDataLoader.Error.invalidData)) {
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
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: RemoteDataLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let request = URLRequest(url: URL(string: "https://example.com")!)
        let sut = RemoteDataLoader(request: request, client: client)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }
    
    private func expect(_ sut: RemoteDataLoader, toCompleteWith expectedResult: RemoteDataLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.loadPosts { receivedResult in
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
    
    private func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
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
    
    private class HTTPClientSpy: HTTPClient {
        private var messages = [(request: URLRequest, completion: (HTTPClient.Result) -> Void)]()
        private var completedRequests = Set<Int>()
        
        var requestedURLs: [URL] {
            return messages.map { $0.request.url! }
        }
        
        func get(for request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) {
            messages.append((request, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            guard !completedRequests.contains(index) else { return }
            completedRequests.insert(index)
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
            guard !completedRequests.contains(index) else { return }
            completedRequests.insert(index)
            let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: code,
                httpVersion: nil,
                headerFields: nil)!
            messages[index].completion(.success((data, response)))
        }
    }
}
