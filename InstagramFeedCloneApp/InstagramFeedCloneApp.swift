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
        let viewModel = FeedViewModel(
            loader: MainQueueDispatchDecorator(
                decoratee: DataLoaderWithFallbackComposite(
                    primary: FeedLoaderCacheDecorator(
                        decoratee: RemoteDataLoader(),
                        cache: LocalDataLoader()
                    ),
                    fallback: LocalDataLoader()
                )))
        return FeedView(viewModel: viewModel)
    }
}
