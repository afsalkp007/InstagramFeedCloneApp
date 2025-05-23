//
//  URLSessionHTTPClient.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 18/04/2025.
//

import Foundation

public final class URLSessionHTTPClient: HTTPClient {
  let session: URLSession
  
  public init(session: URLSession) {
    self.session = session
  }
  
  private struct UnexpectedValuesRepresentation: Error {}
}

extension URLSessionHTTPClient {
    private struct URLSessionTaskWrapper: HTTPClientTask {
      let wrapper: URLSessionTask
      
      func cancel() {
        wrapper.cancel()
      }
    }

    public func get(for request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        let task = session.dataTask(with: request) { data, response, error in
            completion(Result {
                if let error = error {
                    throw error
                } else if let data = data, let response = response as? HTTPURLResponse {
                    return (data, response)
                } else {
                    throw UnexpectedValuesRepresentation()
                }
            })
        }
        task.resume()
        return URLSessionTaskWrapper(wrapper: task)
    }
}
