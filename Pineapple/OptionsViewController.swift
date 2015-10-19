//
//  OptionsViewController.swift
//  Pineapple
//
//  Created by Valentin Perez on 10/18/15.
//  Copyright © 2015 Valpe Technologies. All rights reserved.
//

import UIKit
import Parse

protocol OptionsViewControllerDelegate {
  func didChooseOption(option: Int)
}

class OptionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  var delegate : OptionsViewControllerDelegate?

  @IBOutlet var optionsTableView: UITableView!
  var options : Array<String>!

    override func viewDidLoad() {
      super.viewDidLoad()

      optionsTableView.dataSource = self
      optionsTableView.delegate = self

      // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
    print("selected \(indexPath.row)")
    delegate?.didChooseOption(indexPath.row)
    
    self.dismissViewControllerAnimated(true, completion: nil)

  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell : OptionTableViewCell = tableView.dequeueReusableCellWithIdentifier("optionCell") as! OptionTableViewCell
    cell.titleLabel.text = options[indexPath.row]
    return cell
  }

  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 88;

  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return options.count;
  }

  //This function is where all the table cell animations magic happens

  func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

    var rotation : CATransform3D

    rotation = CATransform3DMakeRotation((90.0*3.14159)/180, 0.0, 0.7, 0.4)

    rotation.m34 = 1.0/(-600)
    cell.layer.shadowColor = UIColor.blackColor().CGColor
    cell.layer.shadowOffset = CGSizeMake(10, 10)
    cell.alpha = 0

    cell.layer.transform = rotation
    cell.layer.anchorPoint = CGPointMake(0.5, 0.5)

    UIView.beginAnimations("rotation", context: nil)
    UIView.setAnimationDuration(0.3)

    cell.layer.transform = CATransform3DIdentity
    cell.alpha = 1
    cell.layer.shadowOffset = CGSizeMake(0, 0)
    UIView.commitAnimations()

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
