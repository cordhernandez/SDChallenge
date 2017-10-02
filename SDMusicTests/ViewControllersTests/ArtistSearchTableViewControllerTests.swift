//
//  ArtistSearchTableViewControllerTests.swift
//  SDMusicTests
//
//  Created by Cordero Hernandez on 10/2/17.
//  Copyright © 2017 SD. All rights reserved.
//

import XCTest
@testable import SDTestMusic

class ArtistSearchTableViewControllerTests: XCTestCase {
    
    var instance: ArtistSearchTableViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        instance = storyboard.instantiateViewController(withIdentifier: "ArtistSearchTableVC") as! ArtistSearchTableViewController
        
        instance.loadView()
        instance.viewDidLoad()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInstantiateViewController() {
        
        XCTAssertNotNil(instance)
    }
    
    func testTableView() {
        
        XCTAssertNotNil(instance.tableView)
    }
    
    func testTableViewDelegate() {
        
        XCTAssertNotNil(instance.tableView.delegate)
    }
    
    func testTableViewDataSource() {
        
        XCTAssertNotNil(instance.tableView.dataSource)
    }
    
    func testNumberOfSections() {
        
        XCTAssert(instance.responds(to: #selector(instance.numberOfSections)))
    }
    
    func testNumberOfRowsInSection() {
        
        XCTAssert(instance.responds(to: #selector(instance.tableView(_:numberOfRowsInSection:))))
    }
    
    func testCellForRowAt() {
        
        XCTAssert(instance.responds(to: #selector(instance.tableView(_:cellForRowAt:))))
    }
    
    func testDidSelectRowAt() {
        
        XCTAssert(instance.responds(to: #selector(instance.tableView(_:didSelectRowAt:))))
    }
    
    func testHeightForRowAt() {
        
        XCTAssert(instance.responds(to: #selector(instance.tableView(_:heightForRowAt:))))
    } 
}
