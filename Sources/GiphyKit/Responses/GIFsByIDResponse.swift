//
//  GIFsByIDResponse.swift
//  GiphyKit
//
//  Created by Adam Young on 25/09/2019.
//

import Foundation

struct GIFsByIDResponse {

  let data: [GIFDTO]

}

extension GIFsByIDResponse: Codable { }
