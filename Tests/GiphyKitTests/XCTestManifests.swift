//
//  XCTestManifests.swift
//  GiphyKitTests
//
//  Created by Adam Young on 25/09/2019.
//

import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
  return [
    testCase(GIFDTOMapperTests.allTests),
    testCase(ImageDTOMapperTests.allTests),

    testCase(GIFByIDRequestTests.allTests),
    testCase(GIFsByIDRequestTests.allTests),

    testCase(GiphyTests.allTests)
  ]
}
#endif
