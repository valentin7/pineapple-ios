//
//  CheckinConfirmationViewController.swift
//  Pineapple
//
//  Created by Valentin Perez on 6/3/15.
//  Copyright (c) 2015 Valpe Technologies. All rights reserved.
//

import UIKit

class CheckinConfirmationViewController: UIViewController {

  internal var beforeVC : UIViewController!
  internal var hoursStaying = 2

  @IBOutlet weak var timeLabel: UILabel!
  
  override func viewDidLoad() {
      super.viewDidLoad()

    UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
      // Do any additional setup after loading the view.
  }

  override func viewDidDisappear(animated: Bool) {
    UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent

  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
  
  override func viewWillDisappear(animated: Bool) {
      beforeVC.dismissViewControllerAnimated(true, completion: nil)
  }

  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return UIStatusBarStyle.Default
  }

  func updateTimeStaying() {
    print("staying \(hoursStaying) , yo.")
  }
    
  @IBAction func soundsGoodClicked(sender: AnyObject) {
      
      self.dismissViewControllerAnimated(true, completion: nil)
      
  }

  @IBAction func timeSliderChanged(sender: AnyObject) {

    let slider : UISlider = sender as! UISlider
    let timeValue : Int = Int(slider.value)

    print("timevalue: "); print(timeValue, terminator: "")

    var timeDescription : String = "\(Int(timeValue)) min"


    switch timeValue {
      case 1: timeDescription = "1 hour"
      case 2: timeDescription = "2 hours"
      case 3: timeDescription = "4 hours"
      case 4: timeDescription = "all day"
      default: timeDescription = "2 hours"
    }

    timeLabel.text = timeDescription
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
