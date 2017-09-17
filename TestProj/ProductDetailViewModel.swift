//
//  ProductDetailViewModel.swift
//  TestProj
//
//  Created by MAHEEP on 17/09/17.
//  Copyright © 2017 MAHEEP. All rights reserved.
//

import Foundation

// This Protocol we make optional as later on in testing we use that.

protocol ProductDetailViewProtocol {
    func dataForcollectionView()
    func updateCell(_ index: Int)
}

protocol ProductDetailViewModelProtocol {
    
    func collectionViewReachedEnd()
    
    func viewModelForCell(at index: Int, selectedCurrency : MultipleCurrencies) -> ProductDetailCellViewModel
    
}



class ProductDetailViewModel :  ProductDetailViewModelProtocol, ProductDetailResponseProtocol {

    // ProductDetailResponse object will receive data as response.
    
    var dataSource : ProductDetailResponse?
    
    // As we dont want to create ProductDetailCellviewModel call again so, we can store that in dataSourceModel Dictionary and will store accouding to key value pair.
    
    var dataSourceViewModel : [Int : ProductDetailCellViewModel] = [:]
    
    
    private var view : ProductDetailViewProtocol?
    
    // Current page will be collectionview current page.
    var currentPages : Int = 0
    
    // Just if we want to put loading indicator.
    
    var isLoadingData : Bool = false
    
    // SelectedCurrency will be coming from server by default we made .INR (Indian currency), but if we need to update currency didSet will call and update it.

    var selectedCurrency : MultipleCurrencies = .INR {
        didSet {
            
            // Update view Model cell currency ..
            
            guard var vm = dataSourceViewModel[currentPages] else {
                return
            }
            
            vm = ProductDetailCellViewModel(withProductDetail: dataSource!, forTag: currentPages, forSelectedCurrency: selectedCurrency)
            dataSourceViewModel[currentPages] = vm
            
            view?.updateCell(currentPages)
            
        }
    }
    
    
    
    // MARK: - Instance Properties
    //
    // ProductDetailRequestor object is responsible for fecthing data from server and give to ProductDetailResponse.
    
    private let api : ProductDetailRequestor = ProductDetailRequestor()

    // Total Pages will be collection view pages.
    
    var totalPages : Int {
        get {
            return Int(roundf(Float(self.dataSource?.products?.count ?? 0)/2.0))
        }
    }
    
    // Once we got init we will start loading from server.
    
    required init(view withView: ProductDetailViewProtocol) {
        self.view = withView
        getProductDetails(productDetailURLString)
    }
    
    // Will be resposible to get data from api.
    
    private func getProductDetails(_ urlString: String?) {
        
        guard urlString != "" || urlString != nil else {
            print("Invalid url")
            return
        }
        
        isLoadingData = true
        api.getProductDetails(urlString!, callback: self)
    }
    
    // MARK :- ProductDetailResponseProtocol
    // Once we got data this will call and update collection view.
    
    func productDetailFetched(_ productDetailResponse: ProductDetailResponse?) {
        guard let productDetail = productDetailResponse  else {
            return
        }
        
        dataSource = productDetail
        
        isLoadingData = false
        view?.dataForcollectionView()
    }
    
    // Error if any came during getting data.
    func errorInFetchingProductDetail(_ error: NSError?) {
        
    }
    
    // MARK :- ProductDetailViewModelProtocol
    // For later pagination if we reach at end of collectionview.
    
    func collectionViewReachedEnd() {
        
    }
    
    // This method will create view model object for ProductDetailCell.
    
    func viewModelForCell(at index: Int, selectedCurrency : MultipleCurrencies) -> ProductDetailCellViewModel {
        
        guard var vm = dataSourceViewModel[index] else {
            let vm = ProductDetailCellViewModel(withProductDetail: dataSource!, forTag: index, forSelectedCurrency: selectedCurrency)
            dataSourceViewModel[index] = vm
            return vm
        }
        vm.selectedCurrency = self.selectedCurrency
        return vm
    }
    
}
