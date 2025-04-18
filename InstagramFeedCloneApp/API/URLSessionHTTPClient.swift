//
//  URLSessionHTTPClient.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 18/04/2025.
//

import Foundation

class URLSessionHTTPClient: HTTPClient {
  let session: URLSession
  
  init(session: URLSession) {
    self.session = session
  }
  
  private struct UnexpectedValuesRepresentation: Error {}
}

extension URLSessionHTTPClient {

    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        let task = session.dataTask(with: url) { data, response, error in
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
    }
}
