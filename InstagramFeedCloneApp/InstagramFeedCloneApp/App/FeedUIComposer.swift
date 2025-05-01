//
//  FeedUIComposer.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 19/04/2025.
//

import Foundation
import CoreData
import InstagramFeedClone
import InstagramFeedCloneiOS

final class FeedUIComposer {
    private init() {}
    
    static func composeFeedView() -> FeedView {
        let url = FeedEndPoint.getFeed(page: 0).url(baseURL: baseURL)
        var request = URLRequest(url: url)
        request.setValue("Bearer \(Constants.API.accessToken.value)", forHTTPHeaderField: "Authorization")
        
        let remoteFeedLoader = RemoteFeedLoader(request: request, client: httpClient)
        let localFeedLoader = LocalFeedLoader(store: store)
        
        let remoteMediaLoader = RemoteMediaDataLoader(client: httpClient)
        let localMediaLoader = LocalMediaDataLoader(store: store)
        
        let mediaLoader: MediaDataLoader = MainQueueDispatchDecorator(
            decoratee: RemoteMediaDataLoaderWithFallbackComposite(
                primary: localMediaLoader,
                fallback: MediaDataLoaderCacheDecorator(
                    decoratee: remoteMediaLoader,
                    cache: localMediaLoader)))
                
        let preloadingAdapter = FeedViewModelPreloadingAdapter(mediaLoader: mediaLoader)
        
        let viewModel = FeedViewModel(mediaLoader: mediaLoader)
                
        let presentationAdapter = FeedLoaderPresentationAdapter(
            feedLoader: MainQueueDispatchDecorator(
                decoratee: FeedLoaderPreloadingDecorator(
                    feedLoader: RemoteFeedLoaderWithFallbackComposite(
                        primary: localFeedLoader,
                        fallback: FeedLoaderCacheDecorator(
                            decoratee: remoteFeedLoader,
                            cache: localFeedLoader)),
                    delegate: preloadingAdapter)),
            viewModel: viewModel)
        
        return FeedView(viewModel: viewModel, delegate: preloadingAdapter, loader: presentationAdapter)
    }
    
    private static var httpClient: URLSessionHTTPClient = {
        let session = URLSession(configuration: .ephemeral)
        return URLSessionHTTPClient(session: session)
    }()
    
    private static var store: FeedStore & MediaDataStore = {
      try! CoreDataFeedStore(
        storeURL: NSPersistentContainer
          .defaultDirectoryURL()
          .appendingPathComponent("feed-store.sqlite"))
    }()

    private static var baseURL: URL {
        return URL(string: "https://api.imgur.com")!
    }
}
