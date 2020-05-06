//
//  JSONEncoder+Default.swift
//  GiphyKit
//
//  Created by Adam Young on 25/09/2019.
//

import Foundation

extension JSONEncoder {

  static var `default`: JSONEncoder {
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    encoder.dateEncodingStrategy = .iso8601
    return encoder
  }

}
