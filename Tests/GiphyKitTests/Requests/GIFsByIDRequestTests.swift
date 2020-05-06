//
//  GIFsByIDRequestTests.swift
//  GiphyKitTests
//
//  Created by Adam Young on 26/09/2019.
//

@testable import GiphyKit
import XCTest

final class GIFsByIDRequestTests: XCTestCase {

  let baseURL = URL(string: "https://api.giphy.com/v1")!
  var apiKey: String = ""

  override func setUp() {
    super.setUp()
    apiKey = UUID().uuidString
  }

  override func tearDown() {
    apiKey = ""
    super.tearDown()
  }

  func testURLRequest_shouldHaveURL() {
    let ids = [
      UUID().uuidString,
      UUID().uuidString,
      UUID().uuidString
    ]

    let expectedResult = URL(string: "\(baseURL)/gifs?api_key=\(apiKey)&ids=\(ids.joined(separator: ","))")!
    let request = GIFsByIDRequest(ids: ids, baseURL: baseURL, apiKey: apiKey)

    let result = request.urlRequest().url

    XCTAssertEqual(result, expectedResult)
  }

}

extension GIFsByIDRequestTests {

  static var allTests = [
    ("testURLRequest_shouldHaveURL", testURLRequest_shouldHaveURL)
  ]

}
