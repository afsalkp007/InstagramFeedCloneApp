//
//  NetworkManager.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 17/04/2025.
//

import Foundation

public final class RemoteFeedLoader: FeedLoader {
    
    private let request: URLRequest
    private let client: HTTPClient
    
    public typealias Result = FeedLoader.Result
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(request: URLRequest, client: HTTPClient) {
        self.request = request
        self.client = client
    }
    
    public func loadFeed(completion: @escaping (Result) -> Void) {
        client.get(for: request) { [weak self] result in
            guard self != nil else { return }
            
            completion(result
                .mapError { _ in Error.connectivity }
                .flatMap { (data, response) in
                    Self.map(data, from: response)
                })
        }
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        Result(catching: {
            try RemoteFeedItemsMapper.map(data, from: response).compactMap { remote in
                return remote.item
            }
        })
    }
}
