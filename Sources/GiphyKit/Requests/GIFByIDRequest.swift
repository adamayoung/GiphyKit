//
//  GIFByIDRequest.swift
//  GiphyKit
//
//  Created by Adam Young on 25/09/2019.
//

import Foundation

struct GIFByIDRequest {

  let id: String
  let baseURL: URL
  let apiKey: String

  init(id: String, baseURL: URL, apiKey: String) {
    self.id = id
    self.baseURL = baseURL
    self.apiKey = apiKey
  }

}

extension GIFByIDRequest {

  func urlRequest() -> URLRequest {
    let url = baseURL
      .appendingPathComponent("gifs")
      .appendingPathComponent(id)

    var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
    urlComponents.queryItems = [
      URLQueryItem(name: "api_key", value: apiKey)
    ]

    return URLRequest(url: urlComponents.url!)
  }

}
