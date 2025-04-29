//
//  FeedUIComposer.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 19/04/2025.
//

import Foundation
import CoreData
import InstagramFeedClone

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

        let viewModel = FeedViewModel(
            feedLoader: MainQueueDispatchDecorator(
                decoratee: RemoteFeedLoaderWithFallbackComposite(
                    primary: FeedLoaderCacheDecorator(
                        decoratee: remoteFeedLoader,
                        cache: localFeedLoader),
                    fallback: localFeedLoader)),
            mediaLoader: MainQueueDispatchDecorator(
                decoratee: RemoteMediaDataLoaderWithFallbackComposite(
                    primary: localMediaLoader,
                    fallback: MediaDataLoaderCacheDecorator(
                        decoratee: remoteMediaLoader,
                        cache: localMediaLoader))))
        return FeedView(viewModel: viewModel)
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
