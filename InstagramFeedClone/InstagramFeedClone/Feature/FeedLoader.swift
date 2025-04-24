//
//  DataLoader.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 18/04/2025.
//

public protocol FeedLoader {
    typealias Result = Swift.Result<[Post], Error>
    
    func loadFeed(completion: @escaping (Result) -> Void)
}
