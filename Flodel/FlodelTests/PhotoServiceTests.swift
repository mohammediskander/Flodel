//
//  PhotoServiceTests.swift
//  FlodelTests
//
//  Created by Mohammed Iskandar on 07/12/2020.
//

import XCTest
@testable import Flodel

class PhotoServiceTest: XCTestCase {
    
    var photoService: PhotoService?
    
    override func setUp() {
        super.setUp()
        UserDefaults.standard.setValue(0.0, forKey: "user.currentLocation.latitude")
        UserDefaults.standard.setValue(0.0, forKey: "user.currentLocation.longitude")
        photoService = PhotoService(session: Constants.sessionConfiguration)
    }
    
    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: "user.currentLocation.latitude")
        UserDefaults.standard.removeObject(forKey: "user.currentLocation.longitude")
        photoService = nil
        super.tearDown()
    }
    
    func testThatFetchPhotosWorks() {
        let completionExpectation = expectation(description: "Execute completion closure.")
        let latittude = 0.0
        let longitude = 0.0
        photoService?.getPhotos(at: (latittude, longitude)) {
            result in
            
            switch result {
            
            case let .success(photos):
                // test that photos has been sorted
                let expectedOutput = 2
                XCTAssertEqual(photos.count, expectedOutput)
                break
            case let .failure(error):
                XCTFail("error \(error)")
                break
            }
            
            completionExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testThatSetSortWorks() {
        
        let completionExpectation = expectation(description: "Execute completion closure.")
        
        let latittude = 0.0
        let longitude = 0.0
        
        let input = PhotosSort.nearest
        self.photoService?.setSort(by: input)
        let expectedOutput = PhotosSort.nearest
        
        XCTAssertEqual(photoService?.sortBy, expectedOutput)
        
        photoService?.getPhotos(at: (latittude, longitude)) {
            result in
            
            switch result {
            
            case let .success(photos):
                // test that photos has been sorted
                XCTAssertLessThan(photos.first!.distance, photos.last!.distance)
                break
            case let .failure(error):
                XCTFail("error \(error)")
                break
            }
            
            completionExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
}
