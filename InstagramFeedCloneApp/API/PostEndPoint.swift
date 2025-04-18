//
//  Constants.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 17/04/2025.
//

import Foundation

enum PostEndPoint {
    case getPosts(page: Int)

    func url(baseURL: URL) -> URL {
        switch self {
        case let .getPosts(page):
            return baseURL.appendingPathComponent("/3/gallery/hot/viral/day/\(page)")
        }
    }
}

