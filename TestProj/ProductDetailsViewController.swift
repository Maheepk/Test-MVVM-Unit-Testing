//
//  ProductDetailsViewController.swift
//  TestProj
//
//  Created by MAHEEP on 10/09/17.
//  Copyright © 2017 MAHEEP. All rights reserved.
//

import UIKit
import SDWebImage

class ProductDetailsViewController : BaseViewController, ProductDetailViewProtocol {
    
    //
    // MARK: - Outlets
    //
    
    @IBOutlet weak var btnSAR: MKButton!
    
    @IBOutlet weak var btnAED: MKButton!
    
    @IBOutlet weak var btnINR: MKButton!
    
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    //
    // MARK:- ProductDetailViewModel object will be responsible for interaction between view and ViewModel.
    //
    
    var viewModel: ProductDetailViewModel!

    //
    // We are initializing viewModel object as very first time, as this need to call with Current view.
    //
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        viewModel = ProductDetailViewModel(view: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewModel = ProductDetailViewModel(view: self)
    }

    
    // MARK: - View Lifecycle
    //
    // ViewDidLoad Calls First time when view load into memory..
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // To show some process is going on..
        if viewModel.isLoadingData {
            showIndicator( "Loading ..")
        }
    }
    
    // MARK:- ProductDetailViewProtocol
    //  dataForcollectionView will call when data came from server and we need to update our current view.
    
    func dataForcollectionView() {
        self.updateLayouts()
        
        // Update page control..
        self.pageControl.numberOfPages = viewModel.totalPages
        
        // To End process is which was going on..
        
        if viewModel.isLoadingData {
            hideIndicator()
        }
        
        // By Default selected INR..
        
        btnCurrentConvertorPress(button: (btnINR)!)
    }
    
    //  updateCell will call once we change anything in ProductDetailResponse, it will just update collection view.
    
    func updateCell(_ index: Int) {
        self.updateLayouts()
    }
    
    //
    // MARK: - IBActions
    // This Action is responsible to update our Currencies.
    // And reload view again.
    
    @IBAction func btnCurrentConvertorPress (button : MKButton) {
     
        resetAllButtons(forView: self.view)
        
        button.selectedBackGroundColor()
        
        switch MultipleCurrencies(rawValue:button.titleLabel?.text ?? "")! {
        case .INR: // For INR
            viewModel.selectedCurrency = .INR
        case .AED: // For AED
            viewModel.selectedCurrency = .AED
        case .SAR: // For SAR
            viewModel.selectedCurrency = .SAR
        }
        
        self.updateLayouts()
        
    }
    
    // MARK:- ScrollView Delegate ..
    // is responsible for getting view current page and update pagecotrol current page.
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewModel.currentPages = Int(productCollectionView.contentOffset.x / productCollectionView.frame.size.width)
        self.pageControl.currentPage = viewModel.currentPages
    }
    
    // MARK:- Update Layouts
    // This method is responsible for updating our current view layout
    //
    
    func updateLayouts() {
        productCollectionView.reloadData()
    }
    
}

// MARK:- CollectionView Delegate source methods
// Extension will responsible will tell, we reach almost at second end of page, so that in future we can do pagination.

extension ProductDetailsViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.totalPages - 1 {
            viewModel.collectionViewReachedEnd()
        }
    }
    
}

// Extension will responsible will tell what to display on CollectionCell.

extension ProductDetailsViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.totalPages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCellIdentifier", for: indexPath) as! ProductCollectionCell
        collectionCell.invalidate(withViewModel: viewModel.viewModelForCell(at: indexPath.row, selectedCurrency: viewModel.selectedCurrency))
        return collectionCell
    }
    
}

// MARK:- UICollectionViewDelegateFlowLayout need size of collectionviewcell.

extension ProductDetailsViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
}


