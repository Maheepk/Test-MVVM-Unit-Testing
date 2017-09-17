//
//  ViewController.swift
//  TestProj
//
//  Created by MAHEEP on 10/09/17.
//  Copyright © 2017 MAHEEP. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
    }
    
    //MARK:- Reachability
    func networkStatusChanged(_ notification: NSNotification) {
        let userInfo = notification.userInfo ?? [:]
        debugPrint(userInfo)
        
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            handleInternetHasBecomeInactive()
        default:
            handleInternetIsAvailable()
        }
    }
    
    func handleInternetIsAvailable () {
        //
    }
    
    func handleInternetHasBecomeInactive () {
        showCustomAlert(title: "Oops!", message: "Your Internet Connection seems to be offline.")
    }
    
    func showCustomAlert(title:String, message:String) {
        UIAlertController.showAlertFor(title, message)
    }
    

    
}
