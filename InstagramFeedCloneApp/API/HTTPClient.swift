//
//  HTTPClient.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 18/04/2025.
//

import Foundation

protocol HTTPClient {
  typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
  func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void)
}
