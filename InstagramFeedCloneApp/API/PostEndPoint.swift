//
//  Constants.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 17/04/2025.
//

import Foundation

struct Constants {
    static let accessToken = "9dd3c015324b01d8660e51cbe43af35e9274d0f6"
}

enum PostEndPoint {
    case getPosts(page: Int)

    public func url(baseURL: URL) -> URL {
        switch self {
        case let .getPosts(page):
            return baseURL.appendingPathComponent("/v1/gallery/hot/viral/day/\(page)")
        }
    }
}

