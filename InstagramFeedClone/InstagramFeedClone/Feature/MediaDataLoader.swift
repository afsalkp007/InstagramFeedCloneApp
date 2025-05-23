//
//  DataLoader.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 18/04/2025.
//

import Foundation

public protocol MediaDataLoaderTask {
  func cancel()
}

public protocol MediaDataLoader {
    typealias Result = Swift.Result<Data, Error>
    
    @discardableResult
    func loadMediaData(from url: URL, completion: @escaping (Result) -> Void) -> MediaDataLoaderTask
}
