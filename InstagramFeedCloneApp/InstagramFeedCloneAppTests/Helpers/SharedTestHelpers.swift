//
//  SharedTestHelpers.swift
//  InstagramFeedCloneAppTests
//
//  Created by Mohamed Afsal on 03/05/2025.
//

import Foundation
import InstagramFeedClone

func uniqueItem() -> FeedItem {
    return FeedItem(type: .imagePNG, url: anyURL())
}

func uniqueItems() -> (models: [FeedItem], local: [LocalFeedItem]) {
    let feed = [uniqueItem()]
    let local = feed.map { LocalFeedItem(type: $0.type, url: $0.url) }
    return (feed, local)
}

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "https://example.com")!
}
