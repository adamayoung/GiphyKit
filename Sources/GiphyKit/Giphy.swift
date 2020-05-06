//
//  Giphy.swift
//  GiphyKit
//
//  Created by Adam Young on 25/09/2019.
//

import Cache
import Combine
import Foundation

public final class Giphy {

  public static let shared = Giphy()

  static let baseURL = URL(string: "https://api.giphy.com/v1")!

  private let dataTaskQueue = DispatchQueue(label: "GiphyKit.HTTP.DataTask", qos: .utility)
  private let streamDataQueue = DispatchQueue(label: "GiphyKit.HTTP.StreamData", qos: .utility)

  private let urlSession: URLSession
  private let decoder: JSONDecoder
  private let gifMapper: GIFDTOMapping
  private let cache: CacheStoreable

  private(set) var apiKey: String?

  init(urlSession: URLSession = .init(configuration: .default), decoder: JSONDecoder = .default,
       gifMapper: GIFDTOMapping = GIFDTOMapper(), cache: CacheStoreable = CacheStore(name: "giphy")) {
    self.urlSession = urlSession
    self.decoder = decoder
    self.gifMapper = gifMapper
    self.cache = cache
  }

  public func setAPIKey(_ apiKey: String) {
    self.apiKey = apiKey
  }

}

extension Giphy {

  public func fetch(withID id: String) -> AnyPublisher<GiphyGIF, GiphyError> {
    guard let apiKey = apiKey else {
      return Fail(error: GiphyError.apiKeyNotSet)
        .eraseToAnyPublisher()
    }

    if let cachedGiphyGif: GiphyGIF = cache.item(forKey: id) {
      return Just(cachedGiphyGif)
        .setFailureType(to: GiphyError.self)
        .eraseToAnyPublisher()
    }

    let request = GIFByIDRequest(id: id, baseURL: Self.baseURL, apiKey: apiKey)
    var urlRequest = request.urlRequest()
    urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")

    return urlSession.dataTaskPublisher(for: urlRequest)
      .retry(3)
      .mapError { error in
        return .network(error)
    }
    .subscribe(on: dataTaskQueue)
    .receive(on: streamDataQueue)
    .map { $0.data }
    .flatMap { [unowned self] data in
      Just(data)
        .decode(type: GIFByIDResponse.self, decoder: self.decoder)
        .mapError { error in
          return .decoding(error)
      }
    }
    .map { [unowned self] response in
      self.gifMapper.map(response.data)
    }
    .handleEvents(receiveOutput: { [unowned self] giphyGIF in
      self.cache.setItem(giphyGIF, forKey: giphyGIF.id)
    })
      .eraseToAnyPublisher()
  }

  public func fetch(withIDs ids: [String], refreshCached: Bool = false) -> AnyPublisher<[GiphyGIF], GiphyError> {
    guard let apiKey = apiKey else {
      return Fail(error: GiphyError.apiKeyNotSet)
        .eraseToAnyPublisher()
    }

    let cachedGiphyGIFs = ids.compactMap { cache.item(forKey: $0) as GiphyGIF? }

    if cachedGiphyGIFs.count == ids.count {
      return Just(cachedGiphyGIFs)
        .setFailureType(to: GiphyError.self)
        .eraseToAnyPublisher()
    }

    let cachedIDs = cachedGiphyGIFs.map { $0.id }
    let ids = ids.filter { !cachedIDs.contains($0) }

    let request = GIFsByIDRequest(ids: ids, baseURL: Self.baseURL, apiKey: apiKey)
    var urlRequest = request.urlRequest()
    urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")

    return urlSession.dataTaskPublisher(for: urlRequest)
      .retry(3)
      .mapError { error in
        return .network(error)
    }
    .subscribe(on: dataTaskQueue)
    .receive(on: streamDataQueue)
    .map { $0.data }
    .flatMap { [unowned self] data in
      Just(data)
        .decode(type: GIFsByIDResponse.self, decoder: self.decoder)
        .mapError { error in
          return .decoding(error)
      }
    }
    .map { [unowned self] response in
      self.gifMapper.map(response.data)
    }
    .handleEvents(receiveOutput: { [unowned self] giphyGIFs in
      giphyGIFs.forEach { self.cache.setItem($0, forKey: $0.id) }
    })
      .eraseToAnyPublisher()
  }

}
