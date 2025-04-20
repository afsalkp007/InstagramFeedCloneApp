//
//  Constants.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 19/04/2025.
//

import Foundation

struct Constants {
    enum API {
        case accessToken
        
        var value: String {
            switch self {
            case .accessToken:
                return "9dd3c015324b01d8660e51cbe43af35e9274d0f6"
            }
        }
    }
    
    enum Cache {
        case key
        case queue
        case mediaCache
        
        var value: String {
            switch self {
            case .key:
                return "com.instagramfeedclone.cache"
            case .queue:
                return "com.instagramfeedclone.queue"
            case .mediaCache:
                return "com.instagramfeedclone.mediaCache"
            }
        }
    }
}
