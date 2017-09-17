//
//  ProductDetailViewModelTests.swift
//  TestProj
//
//  Created by MAHEEP on 11/09/17.
//  Copyright © 2017 MAHEEP. All rights reserved.
//

import XCTest
@testable import TestProj

class ProductDetailViewModelTests: XCTestCase, ProductDetailViewProtocol  {
    
    // We set this forse unwarp because we are assure we will set in later its object.
    
    var viewModel : ProductDetailViewModel!
    
    var viewModelForCell : ProductDetailCellViewModel!

    var expectationForTestIfNoData : XCTestExpectation!
    
    override func setUp() {
        super.setUp()
        
        viewModel = ProductDetailViewModel(view: self)
        
        // We gave 5.0 seconds delay as it will take from server to process data.
        // GIVEN testIfNoData..
        expectationForTestIfNoData = self.expectation(description: "Api is working perfect..")
        

    }
    
    // This will call when, got response from server..
    func dataForcollectionView() {
        // WHEN testIfNoData..
        expectationForTestIfNoData.fulfill()
        XCTAssertNotNil(viewModel.dataSource)
        
    }
    
    func updateCell(_ index: Int) {
        
    }
    
    
    
    // Test Cases..
    // 1. Check data is comming from Cloud.
    
    func testIfNoData() {
        // THEN testIfNoData..
        wait(for: [expectationForTestIfNoData], timeout: 10.0)
        
    }
    
}
