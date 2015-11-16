//
//  GradeComputerViewController.swift
//  Grade Manager
//
//  Created by Cassidy Wang on 11/5/15.
//  Copyright © 2015 Cassidy Wang. All rights reserved.
//

import UIKit
import Foundation

class GradeComputerViewController: UIViewController {
    
    //TODO: SOMETIMES DOES NOT RUN BEFORE KEYBOARD IS SHOWN
    var activeField: UITextField?
    
    @IBAction func beginEditing(sender: UITextField) {
        activeField = sender
    }
    
    @IBOutlet weak var loginWindow: UIView!
    @IBOutlet weak var loginWindowCenter: NSLayoutConstraint!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Calls function to dismiss keyboard if view is touched
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        //Add keyboard notification observers when view has loaded
        addKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Removes keyboard notification observers when view disappears
        removeKeyboardNotifications()
    }
    
    //Close keyboard
    func dismissKeyboard() {
        view.endEditing(true)
    }

    //////////////////////////////////////////////////////////////////
    //FUNCTIONALITY BLOCK: Move text field if obstructed by keyboard//
    //////////////////////////////////////////////////////////////////
    //TODO: QUICKTYPE BUGSSSSSAGHGHGH
    func addKeyboardNotifications() {
        //Adds notifications for keyboard show/hide
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillChangeFrame:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotifications() {
        //Removes notifications for keyboard show/hide
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillChangeFrame(notification: NSNotification) {
        //Adjust view according to keyboard size
        let userInfo = notification.userInfo!
        let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
        
        //Establishes location of top of keyboard relative to view coordinates
        let keyboardHeight = keyboardFrame!.height
        let keyboardTop = self.view.frame.height - keyboardHeight
        
        //Distance from center of login window to top of keyboard
        let windowCenterToKeyboardTop = keyboardTop - loginWindow.center.y
        
        if let field = activeField {
            let fieldCenter = field.center.y + (self.view.frame.height/2.0 - loginWindow.frame.height/2.0)
            let fieldHeight = field.frame.height
            let fieldBottom = fieldCenter + (fieldHeight/2.0)
            let fieldToWindowCenter = loginWindow.center.y - fieldBottom
            print("login window center: \(loginWindow.center.y)")
            print("field bottom: \(fieldBottom)")
            print("field bottom to window center: \(fieldToWindowCenter)")
        
            //Moves field to center location, moves center location to top of keyboard
            let newConstant = -10 + fieldToWindowCenter + windowCenterToKeyboardTop
                
            if newConstant == loginWindowCenter.constant { return }
                
            UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
                    self.loginWindowCenter.constant = newConstant
                    self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
            self.loginWindowCenter.constant = 0.0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    ///////////////////////////
    //END FUNCTIONALITY BLOCK//
    ///////////////////////////
    
    //Handles login process
    @IBAction func login() {
        print("logging in...")
    }
}
