//
//  NetworkManager.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 17/04/2025.
//

import Foundation

public final class RemoteDataLoader: DataLoader {
    
    private let request: URLRequest
    private let client: HTTPClient
    
    public typealias Result = DataLoader.Result
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    public init(request: URLRequest, client: HTTPClient) {
        self.request = request
        self.client = client
    }
    
    public func loadPosts(completion: @escaping (Result) -> Void) {
        client.get(for: request) { result in
            switch result {
            case let .success((data, response)):
                completion(Self.map(data, from: response))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let posts = try RemoteDataItemMapper.map(data, from: response)
            return .success(posts)
        } catch {
            return .failure(error)
        }
    }
}
