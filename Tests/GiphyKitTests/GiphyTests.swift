//
//  GiphyTests.swift
//  GiphyKitTests
//
//  Created by Adam Young on 26/09/2019.
//

@testable import GiphyKit
import XCTest

final class GiphyTests: XCTestCase {

  let baseURL = URL(string: "https://api.giphy.com/v1")!
  var apiKey: String!
  var giphy: Giphy!
  private var mockGIFDTOMapper: MockGIFDTOMapper!

  override func setUp() {
    super.setUp()

    apiKey = UUID().uuidString

    let config = URLSessionConfiguration.ephemeral
    config.protocolClasses = [TestURLProtocol.self]
    let urlSession = URLSession(configuration: config)

    mockGIFDTOMapper = MockGIFDTOMapper()

    self.giphy = Giphy(urlSession: urlSession, gifMapper: mockGIFDTOMapper)
  }

  override func tearDown() {
    self.apiKey = nil
    TestURLProtocol.loadingHandler = nil
    self.mockGIFDTOMapper = nil
    self.giphy = nil

    super.tearDown()
  }

  func testSetAPIKey() {
    giphy.setAPIKey(apiKey)
    XCTAssertEqual(giphy.apiKey, apiKey)
  }

  func testFetch_whenNoAPIKeySet_shouldReturnError() {
    let fetchExpectation = expectation(description: "Fetch")

    let cancellable = giphy.fetch(withID: UUID().uuidString)
      .sink(receiveCompletion: { result in
        switch result {
        case .failure(let error):
          switch error {
          case .apiKeyNotSet:
            fetchExpectation.fulfill()

          default:
            break
          }

        default:
          break
        }
      }, receiveValue: { _ in })

    waitForExpectations(timeout: 5) { error in
      if let error = error {
        print("Error: \(error.localizedDescription)")
      }

      cancellable.cancel()
    }
  }

  func testFetch_whenNotCachedGiphyGIF_shouldReturnGiphyGIF() {
    let id = "abc123"
    let (giphyGIFResponse, responseData) = createGiphyGIFResponse(id: id)

    let expectedResult = mockGIFDTOMapper.map(giphyGIFResponse.data)
    let expectedURL = URL(string: "\(baseURL)/gifs/\(id)?api_key=\(apiKey!)")!

    TestURLProtocol.loadingHandler = { request in
      XCTAssertEqual(request.url, expectedURL)

      let acceptHeader = request.allHTTPHeaderFields?["Accept"]
      XCTAssertEqual(acceptHeader, "application/json")

      let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
      return (response, responseData, nil)
    }

    giphy.setAPIKey(apiKey)

    let fetchExpectation = expectation(description: "Fetch")

    let cancellable = giphy.fetch(withID: id)
      .sink(receiveCompletion: { _ in
      }, receiveValue: { result in
        XCTAssertEqual(result, expectedResult)
        fetchExpectation.fulfill()
      })

    waitForExpectations(timeout: 5) { error in
      if let error = error {
        print("Error: \(error.localizedDescription)")
      }

      cancellable.cancel()
    }
  }

}

extension GiphyTests {

  static var allTests = [
    ("testFetch_whenNoAPIKeySet_shouldReturnError", testFetch_whenNoAPIKeySet_shouldReturnError),
    ("testFetch_whenNotCachedGiphyGIF_shouldReturnGiphyGIF", testFetch_whenNotCachedGiphyGIF_shouldReturnGiphyGIF)
  ]

}

extension GiphyTests {

  func createGiphyGIFResponse(id: String) -> (GIFByIDResponse, Data) {
    let stillImageDTO = ImageDTO(url: URL(string: "https://giphy.com/still.gif")!, width: "0", height: "0")
    let animatedImageDTO = ImageDTO(url: URL(string: "https://giphy.com/animated.gif")!, width: "0", height: "0")
    let imagesDTO = ImagesDTO(originalStill: stillImageDTO, original: animatedImageDTO)
    let dto = GIFDTO(id: id, title: "Some title", images: imagesDTO)

    let response = GIFByIDResponse(data: dto)
    guard let data = try? JSONEncoder.default.encode(response) else {
      XCTFail("Failed encoding GiphyGIFDTO")
      return (response, Data())
    }

    return (response, data)
  }

}

private struct MockGIFDTOMapper: GIFDTOMapping {

  func map(_ dto: GIFDTO) -> GiphyGIF {
    let still = map(dto.images.originalStill)
    let animated = map(dto.images.original)
    return GiphyGIF(id: dto.id, title: dto.title, still: still, animated: animated)
  }

  func map(_ dtos: [GIFDTO]) -> [GiphyGIF] {
    dtos.map(map)
  }

  private func map(_ dto: ImageDTO) -> GiphyImage {
    let width = Int(dto.width) ?? 0
    let height = Int(dto.height) ?? 0
    let size = CGSize(width: width, height: height)
    return GiphyImage(url: dto.url, size: size)
  }

}
