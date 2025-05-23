//
//  Constants.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 17/04/2025.
//

import Foundation

public enum FeedEndPoint {
    case getFeed(page: Int)

    public func url(baseURL: URL) -> URL {
        switch self {
        case let .getFeed(page):
            return baseURL.appendingPathComponent("/3/gallery/hot/viral/day/\(page)")
        }
    }
}

