//
//  GIFDTO.swift
//  GiphyKit
//
//  Created by Adam Young on 25/09/2019.
//

import Foundation

struct GIFDTO {

  let id: String
  let title: String
  let images: ImagesDTO

}

extension GIFDTO: Codable { }
