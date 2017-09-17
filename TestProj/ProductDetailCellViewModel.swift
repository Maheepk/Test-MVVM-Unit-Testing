//
//  ProductDetailCellViewModel.swift
//  TestProj
//
//  Created by MAHEEP on 17/09/17.
//  Copyright © 2017 MAHEEP. All rights reserved.
//

import UIKit
import SDWebImage

struct ProductDetailCellViewModel {
    
    // DataSource
    private var dataSource : ProductDetailResponse?
    
    // TotalProducts will be number of products
    private var totalProducts : Int {
        get {
            return self.dataSource?.products?.count ?? 0
        }
    }
    
    private var tagValue : Int = 0
    
    var firstProduct : Product? {
        get {
            let firstProductIndex = (tagValue * 2)
            return self.dataSource?.products?[firstProductIndex]
        }
    }
    
    var secondProduct : Product? {
        get {
            let secondProductIndex = (totalProducts - 1) >= (tagValue * 2) + 1 ? (tagValue * 2) + 1 : nil
            if let _secondProductIndex = secondProductIndex {
                return self.dataSource?.products?[_secondProductIndex]
            }
            return nil
        }
    }
    
    var selectedCurrency : MultipleCurrencies = .INR
    
    init(withProductDetail productDetail: ProductDetailResponse, forTag : Int , forSelectedCurrency : MultipleCurrencies) {
        self.dataSource = productDetail
        self.tagValue = forTag
        self.selectedCurrency = forSelectedCurrency
    }
    
    func updateCurrency(from: MultipleCurrencies, to : MultipleCurrencies, value : CGFloat) -> String {
        
        var convertedValue : CGFloat = 0
        
        var conversion : Conversion!
        
        if let _conversion = getCurrencyFactor(from: from, to: to) {
            conversion = _conversion
            
            convertedValue = value * StringToCGFloat(str: conversion.rate ?? "")!
            
        } else {
            conversion = getCurrencyFactor(from: to, to: from)
            
            convertedValue = value / StringToCGFloat(str: conversion.rate ?? "")!
            
        }
        
        return getPriceString(convertedValue)
        
    }    
    
    func getCurrencyFactor(from: MultipleCurrencies, to : MultipleCurrencies) -> Conversion? {
        
        return self.dataSource?.conversion?.filter({ $0.from == from && $0.to == to}).first
    }
    
    var title : String {
        get {
            guard let title = self.dataSource?.title else {
                return ""
            }
            
            return title
        }
    }
    
    func showDescription(forProduct : Product?) -> String {
        if let _desc = forProduct?.name {
            return _desc
        }
        return ""
    }
    
    func ShowDiscount(forProduct : Product?) -> String {
        if let _desc = forProduct?.description {
            return _desc
        }
        return ""
    }
    
    func showDiscountPercent(forProduct : Product?) -> String {
        if let _ = forProduct {
            return " 20% Off "
        }
        return ""
    }
    
    func showPrice(forProduct : Product?) -> String {
        if let product = forProduct {
            
            if product.currency != selectedCurrency {
                product.price = self.updateCurrency(from: (product.currency)!, to: self.selectedCurrency , value: StringToCGFloat(str: (product.price)!)!)
                product.currency = selectedCurrency
            }
            
            return addCurrencySymbol(price: product.price, selectedCurrency: selectedCurrency)!
        }
        return ""
    }
    
    func showImage(imageView view: UIImageView, forProduct : Product?){
        if let url = forProduct?.url {
            view.sd_setImage(with: URL(string: url))
        } else {
            view.image = nil
        }
        
    }
  
}
