//
//  GiphyImage.swift
//  GiphyKit
//
//  Created by Adam Young on 25/09/2019.
//

import CoreGraphics
import Foundation

public struct GiphyImage {

  public let url: URL
  public let size: CGSize

  public init(url: URL, size: CGSize) {
    self.url = url
    self.size = size
  }

}

extension GiphyImage: Codable { }

extension GiphyImage: Equatable { }
