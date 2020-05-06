//
//  GIFDTOMapper.swift
//  GiphyKit
//
//  Created by Adam Young on 25/09/2019.
//

import Foundation

protocol GIFDTOMapping {

  func map(_ dto: GIFDTO) -> GiphyGIF

  func map(_ dtos: [GIFDTO]) -> [GiphyGIF]

}

struct GIFDTOMapper: GIFDTOMapping {

  private let imageMapper: ImageDTOMapping

  init(imageMapper: ImageDTOMapping = ImageDTOMapper()) {
    self.imageMapper = imageMapper
  }

  func map(_ dto: GIFDTO) -> GiphyGIF {
    let still = imageMapper.map(dto.images.originalStill)
    let animated = imageMapper.map(dto.images.original)

    return GiphyGIF(id: dto.id, title: dto.title, still: still, animated: animated)
  }

  func map(_ dtos: [GIFDTO]) -> [GiphyGIF] {
    dtos.map(map)
  }

}
