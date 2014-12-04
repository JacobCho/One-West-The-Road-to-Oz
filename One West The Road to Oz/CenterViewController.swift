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

class CenterViewController: UIViewController {
    
    var delegate : CenterViewControllerDelegate?


    @IBOutlet weak var containerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        var navBarButton = UIBarButtonItem(image: UIImage(named: "HamburgerIcon"), style: UIBarButtonItemStyle.Plain, target: self, action: "navDrawerButtonPressed:")
        navigationItem.leftBarButtonItem = navBarButton
       
    }
    @IBAction func navDrawerButtonPressed(sender: UIBarButtonItem) {
        delegate?.toggleLeftPanel?()
    }


}
