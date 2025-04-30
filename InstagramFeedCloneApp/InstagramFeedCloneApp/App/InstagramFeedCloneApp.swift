//
//  InstagramFeedCloneApp.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 17/04/2025.
//

import SwiftUI
import InstagramFeedCloneiOS

@main
struct InstagramLikeFeedApp: App {
    
    var body: some Scene {
        WindowGroup {
            makeFeedView()
        }
    }
    
    func makeFeedView() -> FeedView {
        return FeedUIComposer.composeFeedView()
    }
}
