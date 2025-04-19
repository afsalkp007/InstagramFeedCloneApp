//
//  HTTPClientSpy.swift
//  InstagramFeedCloneAppTests
//
//  Created by Mohamed Afsal on 19/04/2025.
//

import Foundation
import InstagramFeedCloneApp

class HTTPClientSpy: HTTPClient {
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
