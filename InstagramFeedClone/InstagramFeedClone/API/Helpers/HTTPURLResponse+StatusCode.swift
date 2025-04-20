//
//  HTTPURLResponse+StatusCode.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 20/04/2025.
//

import Foundation

extension HTTPURLResponse {
  private static var OK_200: Int { 200 }
  
  var isOK: Bool {
    return statusCode == Self.OK_200
  }
}
