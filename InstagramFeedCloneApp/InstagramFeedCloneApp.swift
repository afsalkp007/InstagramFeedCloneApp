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
        
        let cacheDecorator = FeedLoaderCacheDecorator(
            decoratee: remoteLoader,
            cache: localLoader)
        
        let fallBackComposite = DataLoaderWithFallbackComposite(
            primary: cacheDecorator,
            fallback: localLoader)

        let viewModel = FeedViewModel(loader: MainQueueDispatchDecorator(
            decoratee: fallBackComposite))
        return FeedView(viewModel: viewModel)
    }
}


