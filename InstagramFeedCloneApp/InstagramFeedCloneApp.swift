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
        let urlString = Constants.API.baseURL.value + Constants.API.postsEndpoint(page: 0).value
        let url = URL(string: urlString)!
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
}
