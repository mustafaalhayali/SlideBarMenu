//
//  CenterVC.swift
//  SideBarMenu
//
//  Created by Mustafa Al-Hayali on 2016-02-24.
//  Copyright © 2016 Mustafa Al-Hayali. All rights reserved.
//

import UIKit

@objc
protocol CenterVCDelegate {
    optional func togglePanel()
    optional func collapseSidePanel()
}


class CenterVC: UIViewController {
    
    
    @IBAction func showMenuPressed(sender: AnyObject) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var delegate : CenterVCDelegate?
        
        
    }

   
}
