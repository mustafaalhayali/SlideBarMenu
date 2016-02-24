//
//  ContainerVC.swift
//  SideBarMenu
//
//  Created by Mustafa Al-Hayali on 2016-02-24.
//  Copyright © 2016 Mustafa Al-Hayali. All rights reserved.
//

import UIKit
import QuartzCore


class ContainerVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

private extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    }
    
    class func leftVC() -> LeftSidePanelVC? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("leftVC") as? LeftSidePanelVC
    }
    
    class func centerVC() -> CenterVC? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("centerVC") as? CenterVC
    }
}
