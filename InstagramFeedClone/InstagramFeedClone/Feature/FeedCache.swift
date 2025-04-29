//
//  DataSaver.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 18/04/2025.
//

public protocol FeedCache {
    typealias Result = Swift.Result<Void, Error>
    
    func saveFeed(_ feed: [FeedItem], completion: @escaping (Result) -> Void)
}
