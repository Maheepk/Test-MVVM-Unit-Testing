//
//  ReusableFunctions.swift
//  TestProj
//
//  Created by MAHEEP on 10/09/17.
//  Copyright © 2017 MAHEEP. All rights reserved.
//

import Foundation
import EZLoadingActivity

func isServerReachable () -> Bool {
    var reachable = false
    let status = Reach().connectionStatus()
    switch status {
    case .offline, .unknown:
        reachable = false
    default:
        reachable = true
    }
    
    return reachable
}

func showIndicator(_ message : String) {
    EZLoadingActivity.show(message, disableUI: true)
}

func hideIndicator () {
    EZLoadingActivity.hide()
}

extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
}

func topMostController() -> UIViewController? {
    
    var presentedVC = UIApplication.shared.keyWindow?.rootViewController
    
    while let pVC = presentedVC?.presentedViewController
    {
        presentedVC = pVC
    }
    
    if presentedVC == nil {
        print("Error: You don't have any views set. You may be calling in viewdidload. Try viewdidappear.")
    }
    
    return presentedVC
}

func StringToCGFloat (str : String) -> CGFloat? {
    guard let n = NumberFormatter().number(from: str) else { return nil}
    return CGFloat(n)
}

func getPriceString(_ value: CGFloat?) -> String
{
    guard let _ = value else {
        return "-"
    }
    return String(format: "%.2f", value!)
}


func addCurrencySymbol(price : String?, selectedCurrency : MultipleCurrencies) -> String? {
    
    guard price != nil else {
        return nil
    }
    
    var amount = ""
    
    switch selectedCurrency {
    case .INR:
        amount = RUPEE_SYMBOL + price!
    case .AED:
        amount = AED_SYMBOL + price!
    case .SAR:
        amount = SAR_SYMBOL + price!
    }
    
    return amount
}

// Reset to Default button background state.

func resetAllButtons(forView view : UIView) {
    for subView in view.subviews {
        if subView.isKind(of: MKButton.self) {
            (subView as! MKButton).defaultBackgroundColor()
        }
    }
}


extension UIAlertController {
    
    class func showAlertFor (_ alertTitle: String?, _ alertMessage: String?) {
        
        var title : String?
        var message : String?
        if let _title = alertTitle {
            title = _title
        } else {
            title = AlertTitle
        }
        
        if let _message = alertMessage {
            message = _message
        } else {
            message = AlertMessage
        }
        
        
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction.init(title: "Ok", style: .cancel, handler: nil)
        
        alertController.addAction(action)
        
        presentAlertVC(alertController)
        
    }
    
    class func presentAlertVC (_ alertVC: UIViewController) {
        guard let viewController = topMostController() else {
            return
        }
        
        if viewController.isMember(of:UIAlertController.self) {
            return
        }
        
        viewController.present(alertVC, animated: true, completion: nil)
    }
    
}

