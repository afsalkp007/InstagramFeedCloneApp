//
//  MediaDataCache.swift
//  InstagramFeedClone
//
//  Created by Mohamed Afsal on 24/04/2025.
//

import Foundation

public protocol MediaDataCache {
  typealias Result = Swift.Result<Void, Error>

  func save(_ data: Data, for url: URL, completion: @escaping (Result) -> Void)
}
