//
//  LoginViewController.swift
//  One West The Road to Oz
//
//  Created by Jacob Cho on 2014-12-09.
//  Copyright (c) 2014 Jacob. All rights reserved.
//

import UIKit
import Parse
import Foundation

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    @IBAction func loginButtonPressed(sender: UIButton) {
        // Check if textfields are not empty
        if self.usernameTextField.text != nil && self.passwordTextField.text != nil {
            
            PFUser.logInWithUsernameInBackground(self.usernameTextField.text, password: self.passwordTextField.text, block: { (user: PFUser!, error: NSError!) -> Void in
                if user != nil {
                    // If successful login
                    let containerViewController = ContainerViewController()
                    self.presentViewController(containerViewController, animated: true, completion: nil)
                    // Clear out textfields
                    self.usernameTextField.text = nil
                    self.passwordTextField.text = nil
                } else {
                    // If login unsuccessful
                    var loginErrorAlert = SCLAlertView()
                    loginErrorAlert.showError(self, title: "Error", subTitle: "There was a problem logging in", closeButtonTitle: "Ok", duration: 0)
                    
                }
            })
            
        }
            // If textfields are empty show alert
        else {
            var incompleteAlert = SCLAlertView()
            incompleteAlert.showError(self, title: "Could Not Log In", subTitle: "Please fill out all textfields", closeButtonTitle: "Ok", duration: 0)
        }
    }
    
    /* UITextFieldDelegate method */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == self.usernameTextField {
            self.passwordTextField.becomeFirstResponder()
        }
        return true
    }
    
    // If user touches outside the keyboard, resign keyboard
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }

}
