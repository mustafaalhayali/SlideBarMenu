//
//  ContainerVC.swift
//  SideBarMenu
//
//  Created by Mustafa Al-Hayali on 2016-02-24.
//  Copyright © 2016 Mustafa Al-Hayali. All rights reserved.
//

import UIKit
import QuartzCore

enum SlideState {
    case panelCollapsed
    case panelExpanded
}

class ContainerVC: UIViewController {
    
    var centerNavigationVC : UINavigationController!
    var centerVC : CenterVC!
    var currentState : SlideState = .panelCollapsed {
        didSet{
            let shouldShowShadow = currentState != .panelCollapsed
            showShadowForCenterViewController(shouldShowShadow)
        }
    }
    var leffPanelVC : LeftSidePanelVC?
    let centerVCExpandedOffset : CGFloat = 60
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centerVC = UIStoryboard.centerVC()
        centerVC.delegate = self
        centerNavigationVC = UINavigationController(rootViewController: centerVC)
        view.addSubview(centerNavigationVC.view)
        addChildViewController(centerNavigationVC)
        
        centerNavigationVC.didMoveToParentViewController(self)
        
        
    }
    
    func animateCenterPanelXPosition(targetPosition targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations:
            {
            self.centerNavigationVC.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
    func showShadowForCenterViewController(shouldShowShadow: Bool) {
        if (shouldShowShadow) {
            centerNavigationVC.view.layer.shadowOpacity = 0.8
        } else {
            centerNavigationVC.view.layer.shadowOpacity = 0.0
        }
    }
}


extension ContainerVC: CenterVCDelegate {
    
    func togglePanel(){
        let notAlreadyExpanded = currentState != .panelExpanded
        if notAlreadyExpanded {
            addLeftPanelViewController()
        }
        animateLeftPanel(notAlreadyExpanded)
    }
    
    
    func addLeftPanelViewController() {
        if leffPanelVC == nil {
            leffPanelVC = UIStoryboard.leftVC()
            addChildSidePanelController(leffPanelVC!)
        }
    }
    
    func addChildSidePanelController(sidePanelVC : LeftSidePanelVC){
        
        view.insertSubview(sidePanelVC.view, atIndex: 0)
        addChildViewController(sidePanelVC)
        sidePanelVC.didMoveToParentViewController(self)
    }
    
    func animateLeftPanel(shouldExpand: Bool) {
        if shouldExpand{
            
            currentState = .panelExpanded
            animateCenterPanelXPosition(targetPosition: CGRectGetWidth(centerNavigationVC.view.frame) - centerVCExpandedOffset)
            }else{
                animateCenterPanelXPosition(targetPosition : 0){ finished in
                    self.currentState = .panelCollapsed
                    self.leffPanelVC!.view.removeFromSuperview()
                    self.leffPanelVC = nil
                    
                }
            }
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
