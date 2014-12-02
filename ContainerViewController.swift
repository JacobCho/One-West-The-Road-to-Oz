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

class ContainerViewController: UIViewController {
    
    var navDrawViewController : NavDrawerViewController?
    let centerPanelExpandedOffset : CGFloat = 60

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.didMoveToParentViewController(self)
    }
    // MARK: Nav Drawer Functions

    @IBAction func navDrawerBarButtonPressed(sender: UIBarButtonItem) {
        toggleLeftPanel()
    }
    
    var currentState : SlideOutState = .BothCollapsed {
        didSet {
            let didShowShadow = currentState != .BothCollapsed
            showShadowForCenterViewController(didShowShadow)
        }
        
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
            
            animateCenterPanelXPosition(targetPosition: CGRectGetWidth(self.navigationController!.view.frame) - centerPanelExpandedOffset)
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
            self.navigationController!.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
    
    
    
    func showShadowForCenterViewController(shouldShowShadow: Bool) {
        if (shouldShowShadow) {
            self.navigationController!.view.layer.shadowOpacity = 0.8
        } else {
            self.navigationController!.view.layer.shadowOpacity = 0.0
        }
    }

}

private extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
    
    class func navDrawerViewController() -> NavDrawerViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("NavDrawerViewController") as? NavDrawerViewController
    }

}
