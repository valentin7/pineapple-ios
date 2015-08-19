//
//  PasswordChangeViewController.swift
//  Pineapple
//
//  Created by Valentin Perez on 7/18/15.
//  Copyright (c) 2015 Valpe Technologies. All rights reserved.
//

import UIKit
import Parse

class PasswordChangeViewController: PAViewController {

  @IBOutlet weak var newPasswordTextField: UITextField!
  @IBOutlet weak var currentPasswordTextField: UITextField!

  let transitionManager = MenuTransitionManager()

    override func viewDidLoad() {
        super.viewDidLoad()
      println("before: \(user)")
      user = PFUser.currentUser()

      println("adter: \(user)")
      self.transitioningDelegate = self.transitionManager
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  @IBAction func endedCurrentPassword(sender: AnyObject) {

    //println("user password, yo: \(user.password)")

    //println("user pass: "

    if (user.password != currentPasswordTextField.text){
      self.showAlertWithText("", title: "Your current password doesn't match")
      currentPasswordTextField.text = ""
    }
  }


//  @IBAction func editingNewPassword(sender: AnyObject) {
//    if (newPasswordTextField.text.length > 5) {
//      saveButton.hidden = false
//    }
//  }
//  @IBAction func tappedSave(sender: AnyObject) {
//    println("user: \(self.user) tapped save")
//
//    if (user.password != currentPasswordTextField.text){
//      self.showAlertWithText("", title: "Your current password doesn't match")
//      currentPasswordTextField.text = ""
//      return
//    }
//
//    if (newPasswordTextField.text.length >= 6) {
//      user.password = newPasswordTextField.text
//      user.saveInBackground()
//      self.dismiss()
//    } else {
//      self.showAlertWithText("Invalid password", title: "Password must be longer than 6 characters")
//    }
//
 // }

  @IBAction func tappedClose(sender: AnyObject) {
    dismiss()
  }

  @IBAction func tappedSendPasswordReset(sender: AnyObject) {

    PFUser.requestPasswordResetForEmailInBackground(user.email!, block: { (result, error) -> Void in

      if (error != nil) {
        self.showAlertWithText("Please make sure your account email is valid", title: "There was an error sending the email.")
      } else {

        let alertController = UIAlertController(title: "Password reset email sent!", message: "Check your Pineapple sign up email.", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
          // ...
          self.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(OKAction)
        
        //self.presentViewController(alertController, animated: true)
        self.presentViewController(alertController, animated: true, completion: nil)


//        self.showAlertWithText("Check your Pineapple sign up email.", title: "Password reset email sent!")
      }

    })

  }
  func dismiss() {
    self.dismissViewControllerAnimated(true, completion: nil)
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
