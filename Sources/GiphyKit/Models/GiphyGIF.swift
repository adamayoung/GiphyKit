//
//  GiphyGIF.swift
//  GiphyKit
//
//  Created by Adam Young on 25/09/2019.
//

import Foundation

public struct GiphyGIF: Identifiable {

  public let id: String
  public let title: String
  public var still: GiphyImage
  public var animated: GiphyImage

  public init(id: String, title: String, still: GiphyImage, animated: GiphyImage) {
    self.id = id
    self.title = title
    self.still = still
    self.animated = animated
  }

}

extension GiphyGIF: Codable { }

extension GiphyGIF: Equatable { }
