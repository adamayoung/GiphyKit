//
//  GiphyError.swift
//  GiphyKit
//
//  Created by Adam Young on 25/09/2019.
//

import Foundation

public enum GiphyError: Error {

  case apiKeyNotSet
  case network(Error)
  case decoding(Error)

}

extension GiphyError: LocalizedError {

  public var errorDescription: String? {
    switch self {
    case .apiKeyNotSet:
      return NSLocalizedString("API Key Not Set", tableName: "GiphyKit", comment: "API Key Not Set")

    case .network:
      return NSLocalizedString("Network Error", tableName: "GiphyKit", comment: "Network Error")

    case .decoding:
      return NSLocalizedString("Cannot Load Data", tableName: "GiphyKit", comment: "Cannot Load Data")
    }
  }

  public var failureReason: String? {
    switch self {
    case .apiKeyNotSet:
      return NSLocalizedString("The Giphy API key has not been set.", tableName: "GiphyKit",
                               comment: "The Giphy API key has not been set.")

    case .network:
      return NSLocalizedString("There was a network error.", tableName: "GiphyKit",
                               comment: "There was a network error.")

    case .decoding(let error):
      return error.localizedDescription
    }
  }

}
