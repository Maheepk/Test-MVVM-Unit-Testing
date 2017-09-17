//
//  ProductCollectionCell.swift
//  TestProj
//
//  Created by MAHEEP on 10/09/17.
//  Copyright © 2017 MAHEEP. All rights reserved.
//

import UIKit
import SDWebImage

class ProductCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var firstShowDescrption: UILabel!
    @IBOutlet weak var firstShowDiscountLabel: UILabel!
    @IBOutlet weak var firstShowPrice: UILabel!
        
    @IBOutlet weak var secondImage: UIImageView!
    @IBOutlet weak var secondShowDiscountLabel: UILabel!
    @IBOutlet weak var secondShowPrice: UILabel!
    @IBOutlet weak var secondShowDescrption: UILabel!
    
    private var viewModel : ProductDetailCellViewModel?
    
    func invalidate(withViewModel viewModel: ProductDetailCellViewModel){
        self.viewModel = viewModel
        invalidate()
    }
    
    private func invalidate(){
        
        self.titleLabel.text = viewModel?.title
        
        viewModel?.showImage(imageView: self.firstImage, forProduct: viewModel?.firstProduct)
        viewModel?.showImage(imageView: self.secondImage, forProduct: viewModel?.secondProduct)
        
        self.firstShowPrice.text = viewModel?.showPrice(forProduct: viewModel?.firstProduct)
        self.secondShowPrice.text = viewModel?.showPrice(forProduct: viewModel?.secondProduct)
        
        self.firstShowDescrption.text = viewModel?.showDescription(forProduct: viewModel?.firstProduct)
        self.secondShowDescrption.text = viewModel?.showDescription(forProduct: viewModel?.secondProduct)
        
        self.firstShowDiscountLabel.text = viewModel?.showDiscountPercent(forProduct: viewModel?.firstProduct)
        self.secondShowDiscountLabel.text = viewModel?.showDiscountPercent(forProduct: viewModel?.secondProduct)
    }
    
}

