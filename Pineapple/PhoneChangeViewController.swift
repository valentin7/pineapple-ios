//
//  PhoneChangeViewController.swift
//  Pineapple
//
//  Created by Valentin Perez on 7/18/15.
//  Copyright (c) 2015 Valpe Technologies. All rights reserved.
//

import UIKit

class PhoneChangeViewController: PAViewController {

  @IBOutlet weak var phoneTextField: UITextField!

  let transitionManager = MenuTransitionManager()


    override func viewDidLoad() {
        super.viewDidLoad()

      self.transitioningDelegate = self.transitionManager

      if let currentPhone = user["phone"] as? String {
        self.phoneTextField.text = currentPhone
      }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  @IBAction func tappedSave(sender: AnyObject) {
    user["phone"] = self.phoneTextField.text
    user.saveEventually()
    self.dismiss()
  }

  @IBAction func tappedClose(sender: AnyObject) {
    dismiss()
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
