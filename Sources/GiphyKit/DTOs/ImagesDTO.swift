//
//  ImagesDTO.swift
//  GiphyKit
//
//  Created by Adam Young on 25/09/2019.
//

import Foundation

struct ImagesDTO {

  let originalStill: ImageDTO
  let original: ImageDTO

}

extension ImagesDTO: Codable { }
