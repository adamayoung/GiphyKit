//
//  ImageDTOMapping.swift
//  GIphyKit
//
//  Created by Adam Young on 25/09/2019.
//

import CoreGraphics
import Foundation

protocol ImageDTOMapping {

  func map(_ dto: ImageDTO) -> GiphyImage

}

struct ImageDTOMapper: ImageDTOMapping {

  func map(_ dto: ImageDTO) -> GiphyImage {
    let width = Int(dto.width) ?? 0
    let height = Int(dto.height) ?? 0
    let size = CGSize(width: width, height: height)
    return GiphyImage(url: dto.url, size: size)
  }

}
