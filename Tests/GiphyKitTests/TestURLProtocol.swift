//
//  TestURLProtocol.swift
//  GiphyKitTests
//
//  Created by Adam Young on 26/09/2019.
//

import Foundation
import XCTest

final class TestURLProtocol: URLProtocol {

  override class func canInit(with request: URLRequest) -> Bool {
    return true
  }

  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    return request
  }

  // swiftlint:disable large_tuple
  static var loadingHandler: ((URLRequest) -> (HTTPURLResponse, Data?, Error?))?
  // swiftlint:enable large_tuple

  override func startLoading() {
    guard let handler = TestURLProtocol.loadingHandler else {
      XCTFail("Loading handler is not set.")
      return
    }

    let (response, data, error) = handler(request)

    guard let responseData = data else {
      client?.urlProtocol(self, didFailWithError: error!)
      return
    }

    client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
    client?.urlProtocol(self, didLoad: responseData)
    client?.urlProtocolDidFinishLoading(self)
  }

  override func stopLoading() { }

}
