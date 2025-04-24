//
//  NetworkManager.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 17/04/2025.
//

import Foundation

public final class RemoteMediaDataLoader: MediaDataLoader {
    private let client: HTTPClient
    
    public typealias Result = MediaDataLoader.Result
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    public enum Error: Swift.Error {
      case connectivity
      case invalidData
    }
    
    private final class HTTPClientTaskWrapper: MediaDataLoaderTask {
      private var completion: ((RemoteMediaDataLoader.Result) -> Void)?
      
      var wrapped: HTTPClientTask?
      
      init(_ completion: @escaping (RemoteMediaDataLoader.Result) -> Void) {
        self.completion = completion
      }
      
      func complete(with result: RemoteMediaDataLoader.Result) {
        completion?(result)
      }
      
      func cancel() {
        preventFurtherCompletions()
        wrapped?.cancel()
      }
      
      private func preventFurtherCompletions() {
        completion = nil
      }
    }
    
    public func loadMediaData(from url: URL, completion: @escaping (Result) -> Void) -> MediaDataLoaderTask {
        let task = HTTPClientTaskWrapper(completion)
        
        let request = URLRequest(url: url)
        task.wrapped = client.get(for: request) { [weak self] result in
            
            guard self != nil else { return }
            
            task.complete(with: result
                .mapError{ _ in return Error.connectivity }
                .flatMap { data, response in
                    let isValidResponse = response.isOK && !data.isEmpty
                    return isValidResponse ? .success(data) : .failure(Error.invalidData)
                })
        }
        return task
    }
}
