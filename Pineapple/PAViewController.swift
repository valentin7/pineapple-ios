//
//  PAViewController.swift
//  Pineapple
//
//  Created by Valentin Perez on 7/18/15.
//  Copyright (c) 2015 Valpe Technologies. All rights reserved.
//

import UIKit
import Parse

class PAViewController: UIViewController {

  var user : PFUser!

    override func viewDidLoad() {
        super.viewDidLoad()
      user = PFUser.currentUser()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


  func showAlertWithText(text: String, title: String) {

    let alert = UIAlertController(title: title, message: text, preferredStyle: .Alert)

    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
    }

    alert.addAction(OKAction)
    self.presentViewController(alert, animated: true, completion: nil)
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
