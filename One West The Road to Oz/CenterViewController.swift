//
//  CenterViewController.swift
//  One West The Road to Oz
//
//  Created by Jacob Cho on 2014-12-02.
//  Copyright (c) 2014 Jacob. All rights reserved.
//

import UIKit

@objc
protocol CenterViewControllerDelegate {
    optional func toggleLeftPanel()

}

class CenterViewController: UIViewController, NavDrawerViewControllerDelegate {
    
    var delegate : CenterViewControllerDelegate?
    var navDrawerViewController : NavDrawerViewController!

    @IBOutlet weak var containerView: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var navBarButton = UIBarButtonItem(image: UIImage(named: "HamburgerIcon"), style: UIBarButtonItemStyle.Plain, target: self, action: "navDrawerButtonPressed:")
        navigationItem.leftBarButtonItem = navBarButton
        

       
    }
    @IBAction func navDrawerButtonPressed(sender: UIBarButtonItem) {
        delegate?.toggleLeftPanel?()
    }
    
    func displayContentController(content: UIViewController) {
        self.addChildViewController(content)
        content.view.frame = self.containerView.frame
        self.view.addSubview(content.view)
        content.didMoveToParentViewController(self)
        
    }
    
    func hideContentController(content: UIViewController) {
        content.willMoveToParentViewController(nil)
        content.view.removeFromSuperview()
        content.removeFromParentViewController()
        
    }
    
    // MARK: NavDrawerViewController Delegate Methods
    
    func goToWorkouts() {
        let workoutsTabVC = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("WorkoutsTabBarController") as UIViewController
        self.displayContentController(workoutsTabVC)
        self.hideContentController(self.childViewControllers[0] as UIViewController)
        delegate?.toggleLeftPanel?()
    }
    
    func goToInfo() {
        let infoVC = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("InfoViewController") as UIViewController
        self.displayContentController(infoVC)
        self.hideContentController(self.childViewControllers[0] as UIViewController)
        delegate?.toggleLeftPanel?()
    }
    
    func goToResults() {
        delegate?.toggleLeftPanel?()
    }
    
    func goToSettings() {
        delegate?.toggleLeftPanel?()
    }
    

}
