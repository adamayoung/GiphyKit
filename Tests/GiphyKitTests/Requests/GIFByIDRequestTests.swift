//
//  GIFByIDRequestTests.swift
//  GiphyKitTests
//
//  Created by Adam Young on 26/09/2019.
//

@testable import GiphyKit
import XCTest

final class GIFByIDRequestTests: XCTestCase {

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
    let id = UUID().uuidString
    let expectedResult = URL(string: "\(baseURL)/gifs/\(id)?api_key=\(apiKey)")!
    let request = GIFByIDRequest(id: id, baseURL: baseURL, apiKey: apiKey)

    let result = request.urlRequest().url

    XCTAssertEqual(result, expectedResult)
  }

}

extension GIFByIDRequestTests {

  static var allTests = [
    ("testURLRequest_shouldHaveURL", testURLRequest_shouldHaveURL)
  ]

}
