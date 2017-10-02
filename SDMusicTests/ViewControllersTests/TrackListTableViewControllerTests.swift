//
//  TrackListTableViewControllerTests.swift
//  SDMusicTests
//
//  Created by Cordero Hernandez on 10/2/17.
//  Copyright © 2017 SD. All rights reserved.
//

import XCTest
@testable import SDTestMusic

class TrackListTableViewControllerTests: XCTestCase {
    
    var instance: TrackListTableViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        instance = storyboard.instantiateViewController(withIdentifier: "TrackListTableVC") as! TrackListTableViewController
        
        instance.loadView()
        instance.viewDidLoad()
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
        
        XCTAssert(instance.responds(to: #selector(instance.numberOfSections(in:))))
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
    
    func testTitleForHeaderInSection() {
        
        XCTAssert(instance.responds(to: #selector(instance.tableView(_:titleForHeaderInSection:))))
    }
    
    func testHeightForHeaderInSection() {
        
        XCTAssert(instance.responds(to: #selector(instance.tableView(_:heightForHeaderInSection:))))
    }
    
    
    
}
