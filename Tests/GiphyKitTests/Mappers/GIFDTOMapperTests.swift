//
//  GIFDTOMapperTests.swift
//  GiphyKitTests
//
//  Created by Adam Young on 25/09/2019.
//

@testable import GiphyKit
import XCTest

final class GIFDTOMapperTests: XCTestCase {

  let stillImageDTO = ImageDTO(url: URL(string: "https://giphy.com/still.gif")!, width: "0", height: "0")
  let animatedImageDTO = ImageDTO(url: URL(string: "https://giphy.com/animated.gif")!, width: "0", height: "0")

  var mapper: GIFDTOMapper!

  override func setUp() {
    super.setUp()

    let imageMapper = MockImageDTOMapper()
    mapper = GIFDTOMapper(imageMapper: imageMapper)
  }

  override func tearDown() {
    mapper = nil
    super.tearDown()
  }

  func testMap_shouldMapID() {
    let expectedResult = "abc123"
    let images = ImagesDTO(originalStill: stillImageDTO, original: animatedImageDTO)
    let dto = GIFDTO(id: expectedResult, title: "Some title", images: images)

    let result = mapper.map(dto)

    XCTAssertEqual(result.id, expectedResult)
  }

  func testMap_shouldMapTitle() {
    let expectedResult = "An amazing Giphy of something funny"
    let images = ImagesDTO(originalStill: stillImageDTO, original: animatedImageDTO)
    let dto = GIFDTO(id: "123", title: expectedResult, images: images)

    let result = mapper.map(dto)

    XCTAssertEqual(result.title, expectedResult)
  }

  func testMap_shouldMapStillImage() {
    let expectedResult = stillImageDTO.url
    let images = ImagesDTO(originalStill: stillImageDTO, original: animatedImageDTO)
    let dto = GIFDTO(id: "123", title: "Some title", images: images)

    let result = mapper.map(dto)

    XCTAssertEqual(result.still.url, expectedResult)
  }

  func testMap_shouldMapAnimatedImage() {
    let expectedResult = animatedImageDTO.url
    let images = ImagesDTO(originalStill: stillImageDTO, original: animatedImageDTO)
    let dto = GIFDTO(id: "123", title: "Some title", images: images)

    let result = mapper.map(dto)

    XCTAssertEqual(result.animated.url, expectedResult)
  }

  func testMap_shouldMapDTOs() {
    let images = ImagesDTO(originalStill: stillImageDTO, original: animatedImageDTO)
    let dtos = [
      GIFDTO(id: "1", title: "Some title 1", images: images),
      GIFDTO(id: "2", title: "Some title 2", images: images),
      GIFDTO(id: "3", title: "Some title 3", images: images),
      GIFDTO(id: "4", title: "Some title 4", images: images)
    ]
    let expectedResult = dtos.map { $0.id }

    let result = mapper.map(dtos).map { $0.id }

    XCTAssertEqual(result, expectedResult)
  }

  static var allTests = [
    ("testMap_shouldMapID", testMap_shouldMapID),
    ("testMap_shouldMapTitle", testMap_shouldMapTitle),
    ("testMap_shouldMapStillImage", testMap_shouldMapStillImage),
    ("testMap_shouldMapAnimatedImage", testMap_shouldMapAnimatedImage),
    ("testMap_shouldMapDTOs", testMap_shouldMapDTOs)
  ]

}

private struct MockImageDTOMapper: ImageDTOMapping {

  func map(_ dto: ImageDTO) -> GiphyImage {
    GiphyImage(url: dto.url, size: .zero)
  }

}
