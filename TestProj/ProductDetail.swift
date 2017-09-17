//
//  ProductDetail.swift
//  TestProj
//
//  Created by MAHEEP on 10/09/17.
//  Copyright © 2017 MAHEEP. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

typealias Currencies = String

enum MultipleCurrencies : Currencies {
    case INR = "INR", AED = "AED", SAR = "SAR"
}

class BaseResponse: NSObject, Mappable {
    
    required override init() {
        //
    }
    
    required init?(map: Map){
        // overrriden by SubClass
    }
    
    func mapping(map: Map) {
        // overrriden by SubClass
    }
}

class ProductDetailResponse: BaseResponse {
    
    var title : String?
    var conversion : [Conversion]?
    var products : [Product]?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        conversion <- map["conversion"]
        title <- map["title"]
        products <- map["products"]
    }
    
    func update(withProductResponse productResponse: ProductDetailResponse) {
        
        self.title = productResponse.title
        self.conversion = productResponse.conversion
        self.products = productResponse.products
    }
}

class Conversion: BaseResponse {
    
    var from : MultipleCurrencies?
    var to : MultipleCurrencies?
    var rate : String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        from <- map["from"]
        to <- map["to"]
        rate <- map["rate"]
        
    }
    
}


class Product: BaseResponse {
    
    var url : String?
    var name : String?
    var price : String?
    var currency : MultipleCurrencies?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        url <- map["url"]
        name <- map["name"]
        price <- map["price"]
        currency <- map["currency"]
        
    }
    
}


// Once we got data sent back, with success and error methods..

protocol ProductDetailResponseProtocol {
    func productDetailFetched(_ productDetailResponse: ProductDetailResponse?)
    func errorInFetchingProductDetail(_ error: NSError?)
}

// Declarating Service protocol and call back.

protocol ServiceProtocol {
    func getProductDetails(_ urlString : URLConvertible, callback: ProductDetailResponseProtocol)
}

// Networking Requestor to fetch data for products.

class ProductDetailRequestor : ServiceProtocol {
    
    func errorForCustomRespone(_ message : String?) -> NSError? {
        return errorForCustomResponse(message, errorCode: CUSTOM_ERROR_CODE)
    }
    
    func errorForCustomResponse(_ message : String?, errorCode : Int) -> NSError? {
        var text : String?
        
        if message != nil && message != "" {
            text = message
        } else {
            text = ERROR_MESSAGE_STRING
        }
        
        let error = NSError(domain: CUSTOM_ERROR_DOMAIN, code: errorCode, userInfo: [CUSTOM_ERROR_INFO_KEY : text!])
        
        return error
        
    }
    
    func defaultHeaders() -> [String : String] {
        return ["Accept" : "application/json"]
    }
    
    func getProductDetails(_ urlString : URLConvertible, callback: ProductDetailResponseProtocol) {
        
        debugPrint("\nRequestHeaders:>> \(defaultHeaders())")
        debugPrint("\nRequestURL:>> \(urlString)")
        
        if !isServerReachable() {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        }
        
        // As we use Alamofire, that will take care of all use case like error handling do {} Catch and in case data is not coming or cash.
        
        Alamofire.request(urlString).response { response in
            
            if let error = response.error {
                let response = (error)
                debugPrint(response)
                
                let error = self.errorForCustomResponse(response.localizedDescription, errorCode: error.code)
                
                callback.errorInFetchingProductDetail(error)
                
            } else {
                
                var parsedData : Any!
                
                if let responseData = response.data {
                    parsedData = try?JSONSerialization.jsonObject(with: responseData , options: []) as! [String: Any]
                }
                
                debugPrint(parsedData)
                
                if parsedData != nil {
                    
                    if  let response : ProductDetailResponse = Mapper<ProductDetailResponse>().map(JSON: parsedData as! [String : Any]) {
                        
                        callback.productDetailFetched(response)
                    }
                }
            }
        }
    }
}
