//
//  SharedTestHelpers.swift
//  InstagramFeedCloneTests
//
//  Created by Mohamed Afsal on 28/04/2025.
//

import Foundation
import InstagramFeedClone

func uniqueItem() -> FeedItem {
    return FeedItem(id: "id", type: .imagePNG, url: anyURL())
}

func uniqueItems() -> (models: [FeedItem], local: [LocalFeedItem]) {
    let feed = [uniqueItem()]
    let local = feed.map { LocalFeedItem(id: $0.id, type: $0.type, url: $0.url) }
    return (feed, local)
}
