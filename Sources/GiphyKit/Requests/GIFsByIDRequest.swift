//
//  GIFsByIDRequest.swift
//  GiphyKit
//
//  Created by Adam Young on 25/09/2019.
//

import Foundation

struct GIFsByIDRequest {

  let ids: [String]
  let baseURL: URL
  let apiKey: String

  init(ids: [String], baseURL: URL, apiKey: String) {
    self.ids = ids
    self.baseURL = baseURL
    self.apiKey = apiKey
  }

}

extension GIFsByIDRequest {

  func urlRequest() -> URLRequest {
    let url = baseURL
      .appendingPathComponent("gifs")

    var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
    urlComponents.queryItems = [
      URLQueryItem(name: "api_key", value: apiKey),
      URLQueryItem(name: "ids", value: ids.joined(separator: ","))
    ]

    return URLRequest(url: urlComponents.url!)
  }

}
