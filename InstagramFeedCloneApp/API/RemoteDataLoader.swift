//
//  NetworkManager.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 17/04/2025.
//

import Foundation

final class RemoteDataLoader: DataLoader {
    
    private let url: URL
    private let client: HTTPClient
    
    typealias Result = DataLoader.Result
    
    init(url: URL, client: HTTPClient) {
      self.url = url
      self.client = client
    }
    
    func loadPosts(completion: @escaping (Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case let .success((data, response)):
                completion(Self.map(data, from: response))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let decodedResponse = try JSONDecoder().decode(Response.self, from: data)
            return .success(decodedResponse.data)
        } catch {
            return .failure(error)
        }
    }
}
