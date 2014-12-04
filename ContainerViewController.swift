//
//  ContainerViewController.swift
//  
//
//  Created by Jacob Cho on 2014-12-01.
//
//

import UIKit
import QuartzCore

enum SlideOutState {
    case BothCollapsed
    case LeftPanelExpanded
    case RightPanelExpanded
}

class ContainerViewController: UIViewController, CenterViewControllerDelegate{
    
    var centerNavigationController : UINavigationController!
    var centerViewController : CenterViewController!
    var navDrawViewController : NavDrawerViewController?
    let centerPanelExpandedOffset : CGFloat = 60
    var currentState : SlideOutState = .BothCollapsed {
        didSet {
            let didShowShadow = currentState != .BothCollapsed
            showShadowForCenterViewController(didShowShadow)
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavController()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    
    // MARK: Nav Drawer Functions
    func setupNavController() {
        centerViewController = UIStoryboard.centerViewController()
        centerViewController.delegate = self
        
        centerNavigationController = UINavigationController(rootViewController: centerViewController)
        view.addSubview(centerNavigationController.view)
        addChildViewController(centerNavigationController)
        
        centerNavigationController.didMoveToParentViewController(self)
        centerNavigationController.navigationBar.barTintColor = UIColor(red: 244.0/255.0, green: 67.0/255.0, blue: 54.0/255.0, alpha: 1)
        centerNavigationController.navigationBar.tintColor = UIColor.whiteColor()
    }

    func toggleLeftPanel() {
        let notAlreadyExpanded = (currentState != .LeftPanelExpanded)
        
        if notAlreadyExpanded {
            addNavDrawerViewController()
        }
        
        animateLeftPanel(shouldExpand: notAlreadyExpanded)
    }
    
    func addNavDrawerViewController() {
        
        if (navDrawViewController == nil) {
            
            navDrawViewController = UIStoryboard.navDrawerViewController()
            
            addNavDrawerController(navDrawViewController!)
        }
    }
    
    func addNavDrawerController(navDrawerController : NavDrawerViewController) {
        view.insertSubview(navDrawerController.view, atIndex: 0)
        
        
        addChildViewController(navDrawerController)
        navDrawerController.didMoveToParentViewController(self)
    }
    
    func animateLeftPanel(#shouldExpand: Bool) {
        if (shouldExpand) {
            currentState = .LeftPanelExpanded
            
            animateCenterPanelXPosition(targetPosition: CGRectGetWidth(self.centerNavigationController.view.frame) - centerPanelExpandedOffset)
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { finished in
                self.currentState = .BothCollapsed
                
                self.navDrawViewController!.view.removeFromSuperview()
                self.navDrawViewController = nil
                
            }
            
        }
    }
    
    func animateCenterPanelXPosition(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0,options: .CurveEaseInOut, animations: {
            self.centerNavigationController.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
    
    
    
    func showShadowForCenterViewController(shouldShowShadow: Bool) {
        if (shouldShowShadow) {
            self.centerNavigationController.view.layer.shadowOpacity = 0.8
        } else {
            self.centerNavigationController.view.layer.shadowOpacity = 0.0
        }
    }
}

private extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
    
    class func navDrawerViewController() -> NavDrawerViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("NavDrawerViewController") as? NavDrawerViewController
    }
    
    class func centerViewController() -> CenterViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("CenterViewController") as? CenterViewController
    }

}
