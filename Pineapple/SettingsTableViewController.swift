//
//  SettingsTableViewController.swift
//  Pineapple
//
//  Created by Valentin Perez on 7/18/15.
//  Copyright (c) 2015 Valpe Technologies. All rights reserved.
//

import UIKit
import Parse
import SVProgressHUD
import MessageUI

class SettingsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {

  @IBOutlet var settingsTableView: UITableView!

  let user = PFUser.currentUser()!
  var parent : UIViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

      parent = self.parentViewController

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
      settingsTableView.delegate = self
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  @IBAction func unwindToMainViewController (sender: UIStoryboardSegue){
    // bug? exit segue doesn't dismiss so we do it manually...
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func tappedSendFeedback(sender: AnyObject) {
    sendFeedback()
  }
  @IBAction func tappedLogout(sender: AnyObject) {
    logout()
  }
    // MARK: - Table view data source

  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if (section == 0){
      let name = user["name"] as! String
      return name
    } else {
      return ""
    }
  }
  override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
    print("YOO")
    if (indexPath.section == 0) {
      print("SECTION 0 DAW")
      switch  indexPath.row {
        case 0:
          print("ch pass")
          let vc = self.storyboard?.instantiateViewControllerWithIdentifier("passwordChangeController") as! PasswordChangeViewController
          parent.presentViewController(vc, animated: true, completion: nil)

        case 1:
          print("Change phone")
          let vc = self.storyboard?.instantiateViewControllerWithIdentifier("phoneChangeController") as! PasswordChangeViewController
          parent.presentViewController(vc, animated: true, completion: nil)
        default: print("Add credit yo")
      }

    } else if (indexPath.section == 1) {
      print("DIFF SECTION 1")
    }

  }

  func sendFeedback() {
    print("TRYNNA SEND FEEDBACK")
    let mailComposeViewController = configuredMailComposeViewController()
    if MFMailComposeViewController.canSendMail() {
      self.presentViewController(mailComposeViewController, animated: true, completion: nil)
    } else {
      self.showSendMailErrorAlert()
    }
  }

  func configuredMailComposeViewController() -> MFMailComposeViewController {
    let mailComposerVC = MFMailComposeViewController()
    mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property

    mailComposerVC.setToRecipients(["hello@pineapple.world"])
    mailComposerVC.setSubject("Feedback for Pineapple")
    mailComposerVC.setMessageBody("", isHTML: false)

    return mailComposerVC
  }

  func showSendMailErrorAlert() {
    let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
    sendMailErrorAlert.show()
  }

  // MARK: MFMailComposeViewControllerDelegate

  func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
    controller.dismissViewControllerAnimated(true, completion: nil)

  }



  func logout(){
    //let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    PFUser.logOut()
    SVProgressHUD.show()

    let vc : OnboardViewController = self.storyboard!.instantiateViewControllerWithIdentifier("onboardController") as! OnboardViewController

    let app : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    SVProgressHUD.dismiss()

    app.window!.rootViewController = vc
  }
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
