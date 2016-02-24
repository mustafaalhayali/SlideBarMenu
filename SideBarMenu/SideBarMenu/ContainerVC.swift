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

class ContainerVC: UIViewController, CenterVCDelegate, UIGestureRecognizerDelegate {
    
    //MARK: Variables
    var centerNavigationVC : UINavigationController!
    var centerVC : CenterVC!
    var currentState : SlideState = .panelCollapsed {
        didSet{
            let shouldShowShadow = currentState != .panelCollapsed
            showShadowForCenterViewController(shouldShowShadow)
        }
    }
    var leftPanelVC : LeftSidePanelVC?
    let centerVCExpandedOffset : CGFloat = 200
    
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centerVC = UIStoryboard.centerVC()
        centerVC.delegate = self
        centerNavigationVC = UINavigationController(rootViewController: centerVC)
        view.addSubview(centerNavigationVC.view)
        addChildViewController(centerNavigationVC)
        
        centerNavigationVC.didMoveToParentViewController(self)
        
        
        //gesture recognizer
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        centerNavigationVC.view.addGestureRecognizer(panGestureRecognizer)
        
        
    }
    
    
    func handlePanGesture(recognizer: UIPanGestureRecognizer){
        
        let userIsDraggingFromLeftToRight = recognizer.velocityInView(view).x > 0
        switch(recognizer.state) {
        case .Began:
            if (currentState == .panelCollapsed) {
                if userIsDraggingFromLeftToRight {
                    addLeftPanelViewController()
                    showShadowForCenterViewController(true)
                }else{
                   
                }
            }
        case .Changed :
            
            if userIsDraggingFromLeftToRight{
                
                let x = recognizer.view!.center.x + recognizer.translationInView(view).x
                if x - recognizer.view!.frame.size.width / 2.0 < 0 {
                    recognizer.view!.center.x = recognizer.view!.frame.size.width / 2.0
                    break
                }
                
                recognizer.view!.center.x = x
                recognizer.setTranslation(CGPointZero, inView: view)
                let userDragLeftToRightValue = recognizer.view!.center.x
                if recognizer.velocityInView(view).x < userDragLeftToRightValue{
                    currentState = .panelExpanded
                }
                
                
            }else if currentState == .panelExpanded{
                
                let x = recognizer.view!.center.x + recognizer.translationInView(view).x
                if x - recognizer.view!.frame.size.width / 2.0 < 0 {
                    recognizer.view!.center.x = recognizer.view!.frame.size.width / 2.0
                    break
                }
                recognizer.view!.center.x = x
                recognizer.setTranslation(CGPointZero, inView: view)
                
                
            }else {
                
                addLeftPanelViewController()
                showShadowForCenterViewController(true)
            }
        
        
        case .Ended:
            if leftPanelVC != nil{
                let viewMovedMoreThanHalfWay = recognizer.view!.center.x > view.bounds.width
                animateLeftPanel(viewMovedMoreThanHalfWay)
            }
        
        default:
            break
        }
    }

    
    //MARK: Animation Functions
    func animateCenterPanelXPosition(targetPosition targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .CurveEaseInOut, animations:
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
    
    func animateLeftPanel(shouldExpand: Bool) {
        if shouldExpand{
            
            currentState = .panelExpanded
            animateCenterPanelXPosition(targetPosition: CGRectGetWidth(centerNavigationVC.view.frame) - centerVCExpandedOffset)
        }else{
            animateCenterPanelXPosition(targetPosition : 0){ finished in
                self.currentState = .panelCollapsed
                self.leftPanelVC!.view.removeFromSuperview()
                self.leftPanelVC = nil
                
            }
        }
    }

    
    //MARK: Delegate Functions
    func togglePanel(){
        let notAlreadyExpanded = currentState != .panelExpanded
        if notAlreadyExpanded {
            addLeftPanelViewController()
        }
        animateLeftPanel(notAlreadyExpanded)
    }
    
    
    func addLeftPanelViewController() {
        if leftPanelVC == nil {
            leftPanelVC = UIStoryboard.leftVC()
            addChildSidePanelController(leftPanelVC!)
        }
    }
    
    func addChildSidePanelController(sidePanelVC : LeftSidePanelVC){
        
        view.insertSubview(sidePanelVC.view, atIndex: 0)
        addChildViewController(sidePanelVC)
        sidePanelVC.didMoveToParentViewController(self)
        
    }
    }


//MARK: Extensions
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
