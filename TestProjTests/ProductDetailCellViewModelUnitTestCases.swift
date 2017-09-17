//
//  ProductDetailCellViewModelUnitTestCases.swift
//  TestProjTests
//
//  Created by MAHEEP on 17/09/17.
//  Copyright © 2017 MAHEEP. All rights reserved.
//

import XCTest

class ProductDetailCellViewModelUnitTestCases: XCTestCase, ProductDetailViewProtocol {
    
    // We set this forse unwarp because we are assure we will set in later its object.
    
    var viewModel : ProductDetailViewModel!
    
    var viewModelForCell : ProductDetailCellViewModel!
    
    var expectationForMultipleValues : XCTestExpectation!

    
    override func setUp() {
        super.setUp()
        
        viewModel = ProductDetailViewModel(view: self)

        // GIVEN Test for MultipleValues ..
        expectationForMultipleValues = self.expectation(description: "MultipleValues are coming perfectly..")
        
    }
    
    // This will call when, got response from server..
    func dataForcollectionView() {
        
        // Once we got data we will initialize viewModelFor Cell object with datasource.
        viewModelForCell = ProductDetailCellViewModel(withProductDetail: (viewModel?.dataSource)!, forTag: 0, forSelectedCurrency: .INR)
        
        calledWhenCellLoads()
    }
    
    func updateCell(_ index: Int) {
        
    }
    
    
    func calledWhenCellLoads() {
        
        // WHEN testIfTitleIsComing
        
        let title = viewModelForCell.title
        let firstShowPrice = viewModelForCell.showPrice(forProduct: viewModelForCell.firstProduct)
        let secondShowPrice = viewModelForCell.showPrice(forProduct: viewModelForCell.secondProduct)
        
        let firstShowDesc = viewModelForCell.showDescription(forProduct: viewModelForCell.firstProduct)
        let secondShowDesc = viewModelForCell.showDescription(forProduct: viewModelForCell.secondProduct)
        
        if title != "" || firstShowPrice != "" || secondShowPrice != "" || firstShowDesc != "" || secondShowDesc != "" {
            // WHEN testIfNoData..
            self.expectationForMultipleValues.fulfill()
            XCTAssertNotNil(title)
        } else {
            XCTAssertNotNil(nil)
        }
        
    }
    
    func testForMultipleValues() {
        // THEN testIfNoData..
        wait(for: [expectationForMultipleValues], timeout: 10.0)
        
    }
    
    
}
