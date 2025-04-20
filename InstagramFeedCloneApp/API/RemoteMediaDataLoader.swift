//
//  NetworkManager.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 17/04/2025.
//

import Foundation

public final class RemoteMediaDataLoader: MediaDataLoader {
    private let httpClient: HTTPClient
    
    public typealias Result = MediaDataLoader.Result
    
    public init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    public func loadMediaData(from url: URL, completion: @escaping (Result) -> Void) {
        let request = URLRequest(url: url)
        httpClient.get(for: request) { result in
            completion(result.mapError { error in
                return error
            }.flatMap { data, response in
                let isValidResponse = response.isOK && !data.isEmpty
                return isValidResponse ? .success(data) : .failure(URLError(.badServerResponse))
            })
        }
    }
}
