//
//  FeedUIComposer.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 19/04/2025.
//

import Foundation
import InstagramFeedClone

final class FeedUIComposer {
    private init() {}
    
    static func composeFeedView() -> FeedView {
        let url = PostEndPoint.getPosts(page: 0).url(baseURL: baseURL)
        var request = URLRequest(url: url)
        request.setValue("Bearer \(Constants.API.accessToken.value)", forHTTPHeaderField: "Authorization")
        
        let remoteFeedLoader = RemoteFeedLoader(request: request, client: httpClient)
        let remoteMediaLoader = RemoteMediaDataLoader(httpClient: httpClient)
        
        let localLoader = LocalFeedLoader(store: store)

        let viewModel = FeedViewModel(
            feedLoader: MainQueueDispatchDecorator(
            decoratee: RemoteFeedLoaderWithFallbackComposite(
                primary: FeedLoaderCacheDecorator(
                    decoratee: remoteFeedLoader,
                    cache: localLoader),
                fallback: localLoader)),
            mediaLoader: MainQueueDispatchDecorator(decoratee: remoteMediaLoader), cacheManager: cacheService)
        return FeedView(viewModel: viewModel)
    }
    
    private static var cacheService: CacheService = {
        return CacheManager()
    }()
    
    private static var httpClient: URLSessionHTTPClient = {
        let session = URLSession(configuration: .ephemeral)
        return URLSessionHTTPClient(session: session)
    }()
    
    private static var store: UserDefaultsFeedStore = {
        return UserDefaultsFeedStore(userDefaults: UserDefaults.standard)
    }()
    
    private static var baseURL: URL {
        return URL(string: "https://api.imgur.com")!
    }
}
