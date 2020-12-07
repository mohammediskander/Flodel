//
//  PhotoRouterTests.swift
//  FlodelTests
//
//  Created by Mohammed Iskandar on 07/12/2020.
//

import XCTest
@testable import Flodel

class PhotoRouterTest: XCTestCase {
    func testsThatAsURLRequestsReturnValidURL() {
        let inputURLRequest = try? PhotoRouter.photosSearch(latitude: 0, longitude: 0, page: 1, sort: .newest).asURLRequest()
        
        let expectedQueryItemsOutput = FlickrConstants.requiredParams.toURLQueryItems()
        for expectedQueryItemOutput in expectedQueryItemsOutput {
            XCTAssertTrue(inputURLRequest!.queryItems!.contains(expectedQueryItemOutput))
        }
        
        let expectedMethodOutput = FlickrConstants.flickrHttpMethod.rawValue
        XCTAssertEqual(inputURLRequest?.httpMethod, expectedMethodOutput)
    }
}
