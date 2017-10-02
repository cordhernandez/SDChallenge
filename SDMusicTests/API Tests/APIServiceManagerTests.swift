//
//  APIServiceManagerTests.swift
//  SDMusicTests
//
//  Created by Cordero Hernandez on 10/2/17.
//  Copyright © 2017 SD. All rights reserved.
//

import XCTest
@testable import SDTestMusic

class APIServiceManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        
        super.tearDown()
    }
    
    func testFetchArtist() {
        
        let artistName = "Bruno"
        let promise = expectation(description: "Completion will be called")
        
        let testFailure: (_ error: NSError) -> Void = { failure in
            
        }
        
        let testCompletion: (_ artists: [Artist]) -> Void = { artists in
            
            if !artists.isEmpty {
                promise.fulfill()
            }
        }
        
        APIServiceManager.sharedManager.fetchArtist(artistName, completion: testCompletion, failure: testFailure)
        waitForExpectations(timeout: 3.0, handler: nil)
    }
    
    func testFetchTracksWithArtistID() {
        
        let artistName = "Radiohead"
        let promise = expectation(description: "Completion will be called")
        
        let testFailure: (_ error: NSError) -> Void = { failure in
            
        }
        
        let testCompletion: (_ tracks: [Track]) -> Void = { tracks in
            
            if !tracks.isEmpty {
                promise.fulfill()
            }
        }
        
        APIServiceManager.sharedManager.fetchTracksWithArtistID(artistName, completion: testCompletion, failure: testFailure)
        waitForExpectations(timeout: 3.0, handler: nil)
    }
}
