//
//  RemoteDataLoaderTests.swift
//  InstagramFeedCloneAppTests
//
//  Created by Mohamed Afsal on 19/04/2025.
//

import XCTest
import InstagramFeedClone

final class LoadDataFromRemoteUseCaseTests: XCTestCase {
    
    func test_loadPosts_deliversConnectivityErrorOnClientError() {
        let (sut, client) = makeSUT()
        let clientError = anyNSError()
        
        expect(sut, toCompleteWith: failure(.connectivity)) {
            client.complete(with: clientError)
        }
    }
    
    func test_loadPosts_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        let samples = [199, 201, 400, 500]
        
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: failure(.invalidData)) {
                client.complete(withStatusCode: code, data: Data(), at: index)
            }
        }
    }
    
    func test_loadPosts_deliversPostsOn200HTTPResponseWithValidData() {
        let (sut, client) = makeSUT()
        
        let item1 = makePost(id: "1", images: [
            Media(id: "1", type: .imageGIF, link: "https://example.com/image1.jpg"),
            Media(id: "2", type: .imageGIF, link: "https://example.com/image2.jpg")])
        
        let item2 = makePost(id: "2", images: [
            Media(id: "1", type: .imageGIF, link: "https://example.com/image1.jpg"),
            Media(id: "2", type: .imageGIF, link: "https://example.com/image2.jpg")])
        
        let posts: [Post] = [item1.model, item2.model]
        
        expect(sut, toCompleteWith: .success(posts)) {
            let data = makeValidJSON(posts: [item1.json, item2.json])
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
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let request = URLRequest(url: anyURL())
        let sut = RemoteFeedLoader(request: request, client: client)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }
    
    private func failure(_ error: RemoteFeedLoader.Error) -> RemoteFeedLoader.Result {
        return .failure(error)
    }
    
    private func expect(_ sut: FeedLoader, toCompleteWith expectedResult: FeedLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
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
    
    private func makePost(id: String, images: [Media]) -> (model: Post, json: [String: Any]) {
        let model = Post(id: id, images: images)
        
        let json: [String: Any] = [
            "id": id,
            "images": [
                [
                    "id": images[0].id,
                    "type": images[0].type.rawValue,
                    "link": images[0].link
                ],
                [
                    "id": images[1].id,
                    "type": images[1].type.rawValue,
                    "link": images[1].link
                ]
            ]
        ]
        
        return (model, json)
    }
    
    private func makeValidJSON(posts: [[String: Any]]) -> Data {
        let json: [String: Any] = [
            "data": posts
        ]
        return try! JSONSerialization.data(withJSONObject: json)
    }
}
