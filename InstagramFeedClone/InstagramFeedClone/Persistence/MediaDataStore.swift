//
//  MediaDataStore.swift
//  InstagramFeedClone
//
//  Created by Mohamed Afsal on 24/04/2025.
//

import Foundation

public protocol MediaDataStore {
  typealias RetrievalResult = Swift.Result<Data?, Error>
  typealias InsertionResult = Swift.Result<Void, Error>
  
  func retrieve(dataForURL url: URL, completion: @escaping (RetrievalResult) -> Void)
  func insert(_ data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void)
}
