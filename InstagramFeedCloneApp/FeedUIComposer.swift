//
//  FeedUIComposer.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 19/04/2025.
//

import Foundation

final class FeedUIComposer {
    private init() {}
    
    static func composeFeedView() -> FeedView {
        let url = PostEndPoint.getPosts(page: 0).url(baseURL: baseURL)
        let remoteLoader = RemoteDataLoader(url: url, client: httpClient)
        let localLoader = LocalDataLoader()

        let viewModel = FeedViewModel(loader: MainQueueDispatchDecorator(
            decoratee: DataLoaderWithFallbackComposite(
                primary: FeedLoaderCacheDecorator(
                    decoratee: remoteLoader,
                    cache: localLoader),
                fallback: localLoader)))
        return FeedView(viewModel: viewModel)
    }
    
    private static var httpClient: URLSessionHTTPClient = {
        let session = URLSession(configuration: .ephemeral)
        return URLSessionHTTPClient(session: session)
    }()
    
    private static var baseURL: URL {
        return URL(string: "https://api.imgur.com")!
    }
}
