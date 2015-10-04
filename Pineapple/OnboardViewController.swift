//
//  OnboardViewController.swift
//  Pineapple
//
//  Created by Valentin Perez on 5/24/15.
//  Copyright (c) 2015 Valpe Technologies. All rights reserved.
//

import UIKit
import Parse
import Spring
import SVProgressHUD


class OnboardViewController: UIViewController {

    @IBOutlet var loginButton: UIButton!
    @IBOutlet var signupButton: UIButton!
    @IBOutlet var emailTextfield: UITextField!
    
    @IBOutlet var alreadyButton: UIButton!
    @IBOutlet var backButton: SpringButton!
    @IBOutlet var passwordTextfield: UITextField!
    @IBOutlet var descriptionLabel: UILabel!
    
    var onSidesHidden = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("tappedOnScreen"))
        
        tap.numberOfTapsRequired = 1
    
        self.view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.signupButton.alpha = 0
        self.descriptionLabel.alpha = 0
        self.alreadyButton.alpha = 0
        
       
        
        self.emailTextfield.hidden = false
        self.passwordTextfield.hidden = false
        self.alreadyButton.hidden = false
        self.loginButton.hidden = false
        self.backButton.hidden = false
        
        loginButton.alpha = 0;
        emailTextfield.alpha = 0;
        passwordTextfield.alpha = 0;
        backButton.alpha = 0;
        
        
//        UIView.animateWithDuration(1.5, delay: 0, options: .CurveEaseIn, animations: {
//            self.moveViewByX(self.emailTextfield, by: -self.view.frame.width)
//            self.emailTextfield.alpha = 0
//            self.moveViewByX(self.passwordTextfield, by: self.view.frame.width)
//            self.passwordTextfield.alpha = 0
//            
//            
//            }, completion: { finished in
//                self.onSidesHidden = true
//                
//        })
        
        showSignup()
        


       // showSignup()
    
        ///self.emailTextfield.frame.origin.x -= self.view.frame.width
    }
    
    override func viewDidAppear(animated: Bool) {
        

    }
    
    func tappedOnScreen() {
        self.view.endEditing(true)
    }
    
    
    @IBAction func tappedSignup(sender: AnyObject) {
        let vc : SignupViewController = self.storyboard!.instantiateViewControllerWithIdentifier("signupController") as! SignupViewController
        
        self.presentViewController(vc, animated: true, completion: nil)
        
        
    }
    @IBAction func tappedAlready(sender: AnyObject) {
        showLogin()
    }
    @IBAction func tappedBack(sender: AnyObject) {
        showSignup()
    }
    
    @IBAction func tappedLogin(sender: AnyObject) {
        logIn()
    }
    
    func moveViewByX(v : UIView, by : CGFloat) {
        var frame = v.frame
        frame.origin.x += by
        v.frame = frame
    }
    
    func showLogin() {
        
        print("showing login")
        self.backButton.alpha = 1

        UIView.animateWithDuration(0.6, delay: 0.0, options: .CurveEaseIn, animations: {
            
            self.signupButton.alpha = 0
            self.descriptionLabel.alpha = 0
            self.alreadyButton.alpha = 0
        
            
            }, completion: { finisheduo in
        })
        
        var whichSide : CGFloat = 1
        
//        if (!self.onSidesHidden) {
//            whichSide = 1
            UIView.animateWithDuration(0.6, delay: 0.5, options: .CurveEaseIn, animations: {
                //self.moveViewByX(self.emailTextfield, by: whichSide*self.view.frame.width)
                self.emailTextfield.alpha = 1
                
               // self.moveViewByX(self.passwordTextfield, by: -whichSide*self.view.frame.width)
                self.passwordTextfield.alpha = 1
                
                self.loginButton.alpha = 1
                
                }, completion: { finished in
                    
                    self.onSidesHidden = false})
       // }
        
       

       
        
        backButton.animation = "squeezeRight"
        backButton.curve = "spring"
        backButton.duration = 1.0
        backButton.animate()
        
        
        
//        alreadyButton.hidden = true;
//        signupButton.hidden = true;
//        descriptionLabel.hidden = true;
    }
    
    func showSignup() {
        
        print("MOVING OUT BRAH")
//        backButton.animation = "squeezeLeft"
//        backButton.animate()

        print("is not hidden so moving out!!", terminator: "")
        UIView.animateWithDuration(1.5, delay: 0, options: .CurveEaseIn, animations: {
           // self.moveViewByX(self.emailTextfield, by: -self.view.frame.width)
            self.emailTextfield.alpha = 0
           // self.moveViewByX(self.passwordTextfield, by: self.view.frame.width)
            self.passwordTextfield.alpha = 0
         
            
            }, completion: { finished in
                
                self.onSidesHidden = true
                
        })
        
    
        
        UIView.animateWithDuration(1.5, delay: 0.5, options: .CurveEaseIn, animations: {
            self.alreadyButton.alpha = 1
            self.signupButton.alpha = 1
            self.descriptionLabel.alpha = 1
            self.loginButton.alpha = 0
            self.backButton.alpha = 0
         
            }, completion: { finished in

        })
        
        
//        UIView.animateWithDuration(1.0, delay: 0, options: .CurveEaseIn, animations: {
//            
//            self.moveViewByX(self.emailTextfield, by: -self.view.frame.width)
//            self.emailTextfield.alpha = 0
//            
//            
//            self.moveViewByX(self.passwordTextfield, by: self.view.frame.width)
//            self.passwordTextfield.alpha = 0
//            
//            }, completion: { finished in
//                
//        })
        
        

//        
//        UIView.animateWithDuration(1.5, delay: 0, options: .CurveEaseIn, animations: {
//            self.descriptionLabel.alpha = 1
//            self.moveViewByX(self.emailTextfield, by: -self.view.frame.width)
//            self.moveViewByX(self.passwordTextfield, by: self.view.frame.width)
//            
//            }, completion: { finished in
//        })
//        
//        UIView.animateWithDuration(1.5, delay: 0.25, options: .CurveEaseIn, animations: {
//            self.alreadyButton.alpha = 1
//            }, completion: { finished in
//        })
//        UIView.animateWithDuration(1.5, delay: 0.5, options: .CurveEaseIn, animations: {
//            self.signupButton.alpha = 1
//            }, completion: { finished in
//        })
//        
//        
//        UIView.animateWithDuration(1.0, delay: 0.5, options: .CurveEaseIn, animations: {
//            
//            
//            }, completion: { finished in
//                
//        })
//        
//        UIView.animateWithDuration(1.0, delay: 0, options: .CurveEaseIn, animations: {
//            
//            self.backButton.alpha = 0
//            self.loginButton.alpha = 0
//            
//            }, completion: { finished in
//                
//        })
        
//        loginButton.hidden = true;
//        emailTextfield.hidden = true;
//        passwordTextfield.hidden = true;
//        backButton.hidden = true;
//        
//        alreadyButton.hidden = false;
//        signupButton.hidden = false;
//        descriptionLabel.hidden = false;
    }
    
    func logIn(){
        
        print("trying to login")
        SVProgressHUD.show()
        if (emailTextfield.hasText() && passwordTextfield.hasText()) {
            PFUser.logInWithUsernameInBackground(emailTextfield.text!, password: passwordTextfield.text!) {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil {
                    // Do stuff after successful login.
                    print("successfull login")
                  print("with pass: \(self.passwordTextfield.text)")
                  print("user pass: \(user?.password)")
                    SVProgressHUD.dismiss()
                    self.showApp()
                    
                    
                } else {
                    SVProgressHUD.dismiss()
                    // The login failed. Check error to see why.
                    UIAlertView(title: "Could not log in", message: "Please double-check your log in info!", delegate: self, cancelButtonTitle: "Ok").show()
                    
                    print("log in error: ")
                    print("error?.description")
                    
                }
            }
        } else {
            SVProgressHUD.dismiss()
            UIAlertView(title: "Don't get too excited!", message: "You forgot your email or password", delegate: self, cancelButtonTitle: "Ok").show();
            
        }
        
    }
    
    func showApp() {
        
        let app : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let tabBarVC : UITabBarController = self.storyboard?.instantiateViewControllerWithIdentifier("tabBarController") as! UITabBarController
        
        app.window?.rootViewController = tabBarVC
    }
    
}
