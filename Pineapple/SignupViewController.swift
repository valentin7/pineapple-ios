//
//  SignupViewController.swift
//  Pineapple
//
//  Created by Valentin Perez on 5/25/15.
//  Copyright (c) 2015 Valpe Technologies. All rights reserved.
//

import UIKit
import Parse
import SVProgressHUD

class SignupViewController: UIViewController, UITextFieldDelegate {

  @IBOutlet var nameTextfield: UITextField!
  @IBOutlet var phoneTextfield: UITextField!
  @IBOutlet var passwordTextfield: UITextField!
  @IBOutlet var emailTextfield: UITextField!
  @IBOutlet var signupButton: UIButton!
  
  @IBOutlet var swipeDownGesture: UISwipeGestureRecognizer!
    var kbHeight: CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneTextfield.delegate = self
        nameTextfield.delegate  = self

        UIView.animateWithDuration(1.0, delay: 1.2, options: .CurveEaseOut, animations: {
            
//            var fabricTopFrame = self.fabricTop.frame
//            fabricTopFrame.origin.y -= fabricTopFrame.size.height
//            
//            var fabricBottomFrame = self.fabricBottom.frame
//            fabricBottomFrame.origin.y += fabricBottomFrame.size.height
//            
//            self.fabricTop.frame = fabricTopFrame
//            self.fabricBottom.frame = fabricBottomFrame
            }, completion: { finished in
                print("Napkins opened!")
        })
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("tappedOnScreen"))
        
        tap.numberOfTapsRequired = 1
        
        self.view.addGestureRecognizer(tap)
        
       // self.view.bringSubviewToFront(signupButton)
        
//        self.emailTextfield.tag = 1
//        self.passwordTextfield.tag = 2
//        self.nameTextfield.tag = 3
//        self.phoneTextfield.tag = 4
       // self.emailTextfield.becomeFirstResponder()
    }
    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        
        print("will APPEAR!")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        switch (textField.tag) {
            case 1: passwordTextfield.becomeFirstResponder()
            case 2: nameTextfield.becomeFirstResponder()
            case 3: phoneTextfield.becomeFirstResponder()
            default:
                emailTextfield.becomeFirstResponder()
    
        }
        
        return true
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize =  (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                kbHeight = keyboardSize.height
                self.animateTextField(true)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.animateTextField(false)
    }
    
    func animateTextField(up: Bool) {
        var movement = (up ? -kbHeight : kbHeight) + 20
        
        UIView.animateWithDuration(0.3, animations: {
            //self.signupButton.frame = CGRectOffset(self.view.frame, 0, movement)
           // self.moveViewByY(self.signupButton, by:  movement)
        })
    }
    func moveViewByY(v : UIView, by : CGFloat) {
        var frame = v.frame
        frame.origin.y += by
        v.frame = frame
    }
    func tappedOnScreen() {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tappedBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }


  @IBAction func swipedDown(sender: AnyObject) {
    print("Swiped down yo!!")
    self.dismissViewControllerAnimated(true, completion: nil)

  }

    func signUp() {
        var user = PFUser()
        
        if (emailTextfield.hasText()) {
            user.username = emailTextfield.text
            user.email = emailTextfield.text
        } else {
            UIAlertView(title: "Oops", message: "You forgot your email.", delegate: self, cancelButtonTitle: "Ah, yes. Thanks!").show()
            return
        }
        
        if (passwordTextfield.hasText()) {
            user.password = passwordTextfield.text
        } else {
            UIAlertView(title: "Oops", message: "You forgot your password!", delegate: self, cancelButtonTitle: "Ah, yes. Thanks!").show()
            return
        }
        
        if (phoneTextfield.hasText()) {
            user["phone"] = phoneTextfield.text
        } else {
             UIAlertView(title: "You forgot your phone!", message: "This is how hotels can get in contact with you.", delegate: self, cancelButtonTitle: "Ah, yes. Thanks!").show()
            return
        }
        
        if (nameTextfield.hasText()) {
            user["name"] = nameTextfield.text
        } else {
            UIAlertView(title: "You forgot your name!", message: "We like calling you by name!", delegate: self, cancelButtonTitle: "Ah, yes. Thanks!").show()
            return
        }
        
        SVProgressHUD.show()
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
                var message = "\(errorString?.description)"

                switch (error.code) {
                    case 125:
                        message = "Invalid email address!"
                    break;
                    default:
                        message = "Please try again later!"
                    break;
                }
                UIAlertView(title: "Oops, couldn't sign you up.", message: message, delegate: self, cancelButtonTitle: "Ok").show()
                print("error signup message: ")
                print(message)
                
                SVProgressHUD.dismiss()
            } else {
                // Hooray! Let them use the app now.
                print("created \(user.email)")
                SVProgressHUD.dismiss()
                self.showApp()  
            }
        }
    }
    
    func showApp() {
        
        let app : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let tabBarVC : UITabBarController = self.storyboard?.instantiateViewControllerWithIdentifier("tabBarController") as! UITabBarController
        
        app.window?.rootViewController = tabBarVC
        
    }
    
    @IBAction func tappedCreate(sender: AnyObject) {
        print("TAPPED CREATE BUTTON")
        self.view.endEditing(true)
        signUp()
    }
    
    @IBAction func createAccount(sender: AnyObject) {
        
        print("tapped create", terminator: "")
        signUp()
        
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
