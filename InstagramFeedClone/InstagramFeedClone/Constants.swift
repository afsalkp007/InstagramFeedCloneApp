//
//  Constants.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 19/04/2025.
//

import Foundation

struct Constants {
    
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
