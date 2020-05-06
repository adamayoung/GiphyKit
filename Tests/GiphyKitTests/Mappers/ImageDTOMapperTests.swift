//
//  ImageDTOMapperTests.swift
//  GiphyKitTests
//
//  Created by Adam Young on 26/09/2019.
//

@testable import GiphyKit
import XCTest

final class ImageDTOMapperTests: XCTestCase {

  var mapper: ImageDTOMapper!

  override func setUp() {
    super.setUp()

    mapper = ImageDTOMapper()
  }

  override func tearDown() {
    mapper = nil

    super.tearDown()
  }

  func testMap_shouldMapURL() {
    let expectedResult = URL(string: "https://giphy.com/image.gif")!
    let dto = ImageDTO(url: expectedResult, width: "", height: "")

    let result = mapper.map(dto)

    XCTAssertEqual(result.url, expectedResult)
  }

  func testMap_whenWidthAndHeightAreValidInts_shouldMapSize() {
    let expectedResult = CGSize(width: 20, height: 10)
    let dto = ImageDTO(url: URL(string: "https://giphy.com/image.gif")!, width: "\(Int(expectedResult.width))",
                               height: "\(Int(expectedResult.height))")

    let result = mapper.map(dto)

    XCTAssertEqual(result.size, expectedResult)
  }

  func testMap_whenWidthIsAnInvalidInt_shouldMapSizeWithWidthAsZero() {
    let expectedResult = CGSize(width: 0, height: 10)
    let dto = ImageDTO(url: URL(string: "https://giphy.com/image.gif")!, width: "",
                               height: "\(Int(expectedResult.height))")

    let result = mapper.map(dto)

    XCTAssertEqual(result.size, expectedResult)
  }

  func testMap_whenHeightIsAnValidInt_shouldMapSizeWithHeightAsZero() {
    let expectedResult = CGSize(width: 20, height: 0)
    let dto = ImageDTO(url: URL(string: "https://giphy.com/image.gif")!, width: "\(Int(expectedResult.width))",
                               height: "")

    let result = mapper.map(dto)

    XCTAssertEqual(result.size, expectedResult)
  }

  func testMap_whenWidthAndHeightAreInvalidInts_shouldMapWidthAndHeightAsZero() {
    let expectedResult = CGSize.zero
    let dto = ImageDTO(url: URL(string: "https://giphy.com/image.gif")!, width: "",
                               height: "")

    let result = mapper.map(dto)

    XCTAssertEqual(result.size, expectedResult)
  }

}

extension ImageDTOMapperTests {

  static var allTests = [
    ("testMap_shouldMapURL", testMap_shouldMapURL),
    ("testMap_whenWidthAndHeightAreValidInts_shouldMapSize", testMap_whenWidthAndHeightAreValidInts_shouldMapSize),
    ("testMap_whenWidthIsAnInvalidInt_shouldMapSizeWithWidthAsZero",
     testMap_whenWidthIsAnInvalidInt_shouldMapSizeWithWidthAsZero),
    ("testMap_whenHeightIsAnValidInt_shouldMapSizeWithHeightAsZero",
     testMap_whenHeightIsAnValidInt_shouldMapSizeWithHeightAsZero),
    ("testMap_whenWidthAndHeightAreInvalidInts_shouldMapWidthAndHeightAsZero",
     testMap_whenWidthAndHeightAreInvalidInts_shouldMapWidthAndHeightAsZero)
  ]

}
