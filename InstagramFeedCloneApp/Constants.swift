//
//  Constants.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 17/04/2025.
//

import Foundation

struct Constants {}

extension Constants {
    enum API {
        case baseURL
        case postsEndpoint(page: Int)
        case accessToken
        
        var value: String {
            switch self {
            case .baseURL:
                return "https://api.imgur.com"
            case let .postsEndpoint(page):
                return "/3/gallery/hot/viral/day/\(page)"
            case .accessToken:
                return "9dd3c015324b01d8660e51cbe43af35e9274d0f6"
            }
        }
    }
}


