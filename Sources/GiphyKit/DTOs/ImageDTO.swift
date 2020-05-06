//
//  ImageDTO.swift
//  GiphyKit
//
//  Created by Adam Young on 25/09/2019.
//

import Foundation

struct ImageDTO {

  let url: URL
  let width: String
  let height: String

}

extension ImageDTO: Codable { }
