//
//  InstagramFeedCloneApp.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 17/04/2025.
//

import SwiftUI

@main
struct InstagramLikeFeedApp: App {
    
    var body: some Scene {
        WindowGroup {
            makeFeedView()
        }
    }
    
    func makeFeedView() -> FeedView {
        let url = PostEndPoint.getPosts(page: 0).url(baseURL: baseURL)
        let remoteLoader = RemoteDataLoader(url: url)
        let localLoader = LocalDataLoader()

        let viewModel = FeedViewModel(loader: MainQueueDispatchDecorator(
            decoratee: DataLoaderWithFallbackComposite(
                primary: FeedLoaderCacheDecorator(
                    decoratee: remoteLoader,
                    cache: localLoader),
                fallback: localLoader)))
        return FeedView(viewModel: viewModel)
    }
    
    var baseURL: URL {
        return URL(string: "https://api.imgur.com")!
    }
}
