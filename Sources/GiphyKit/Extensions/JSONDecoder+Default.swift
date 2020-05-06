//
//  JSONDecoder+Default.swift
//  GiphyKit
//
//  Created by Adam Young on 25/09/2019.
//

import Foundation

extension JSONDecoder {

  static var `default`: JSONDecoder {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    decoder.dateDecodingStrategy = .iso8601
    return decoder
  }

}
