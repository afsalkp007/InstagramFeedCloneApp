//
//  Localized.swift
//  InstagramFeedClone
//
//  Created by Mohamed Afsal on 01/05/2025.
//

import Foundation

public enum Localized {
    case title
    case error
    case ok
    
    public var value: String {
        switch self {
        case .title:
            return localized(key: "FEED_VIEW_TITLE")
        case .error:
            return localized(key: "FEED_VIEW_ERROR")
        case .ok:
            return localized(key: "FEED_VIEW_OK")
        }
    }
    
    private func localized(key: String) -> String {
        return NSLocalizedString(
            key,
            tableName: "Item",
            bundle: Bundle(for: FeedViewModel.self),
            comment: ""
        )
    }
}
