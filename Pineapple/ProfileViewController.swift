//
//  ProfileViewController.swift
//  Pineapple
//
//  Created by Valentin Perez on 5/25/15.
//  Copyright (c) 2015 Valpe Technologies. All rights reserved.
//

import UIKit
import Parse
import SVProgressHUD

class ProfileViewController: PAViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  @IBOutlet weak var profileImageView: UIImageView!
    
  @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var recognizeTapView: UIView!
  @IBOutlet weak var phoneTextField: UITextField!
  @IBOutlet weak var nameLabel: UILabel!
    
  @IBOutlet weak var emailLabel: UILabel!
    
  @IBOutlet weak var addPhotoLabel: UILabel!
    
  //  private var scanVC : CardIOPaymentViewController!
    
  var imagePicker : UIImagePickerController!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.tabBarItem.imageInsets = UIEdgeInsetsMake(6.0, 0.0, -6.0, 0.0);



    if (PFUser.currentUser() == nil) {
      setForNoUser()

      return;
    }



    let user : PFUser = PFUser.currentUser()!
    
//    emailLabel.text = user.email
//    nameLabel.text = user["name"] as? String
//    phoneTextField.text = user["phone"] as? String

    self.view.bringSubviewToFront(addPhotoLabel)
    //scanVC = CardIOPaymentViewController(paymentDelegate: self)
    
    imagePicker = UIImagePickerController()
    imagePicker.delegate = self


    if let userImageFile = user["profilePhoto"] as? PFFile {
      userImageFile.getDataInBackgroundWithBlock({ (imageData, error) -> Void in
        if !(error != nil) {
          self.setForImage()
          let imagePhoto = UIImage(data:imageData!)
          self.profileImageView.image = imagePhoto
        }
      })
    }

    let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("tappedOnScreen"))

    tap.numberOfTapsRequired = 1
    
    self.recognizeTapView.addGestureRecognizer(tap)
    
    self.view.bringSubviewToFront(self.profileImageView)
    
    self.profileImageView.userInteractionEnabled = true
    
    let tapPhoto : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("changePhoto"))
    
    tapPhoto.numberOfTapsRequired = 1
      
    self.profileImageView.addGestureRecognizer(tapPhoto)
  }

  func setForNoUser() {
    addPhotoLabel.text = "Tap to Sign Up"

    self.view.bringSubviewToFront(self.profileImageView)
    self.profileImageView.userInteractionEnabled = true

    let tapPhoto : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("showSignUp"))
    tapPhoto.numberOfTapsRequired = 1
    self.profileImageView.addGestureRecognizer(tapPhoto)
  }

  func showSignUp() {
    let vc : OnboardViewController = self.storyboard!.instantiateViewControllerWithIdentifier("onboardController") as! OnboardViewController

    let app : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    app.window!.rootViewController = vc
  }

  func tappedOnScreen (){
      self.view.endEditing(true)
  }

  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }


  
  func changePhoto() {
      imagePicker.allowsEditing = false
      imagePicker.sourceType = .PhotoLibrary
      
      presentViewController(imagePicker, animated: true, completion: nil)
  }





  // MARK: - UIImagePickerControllerDelegate Methods

  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
      if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
        self.setForImage()
        profileImageView.image = pickedImage

        let scaledImage = resizeImage(pickedImage, targetSize: CGSizeMake(320, 320))
        let imageData = UIImagePNGRepresentation(scaledImage)
        let imageFile:PFFile = PFFile(data: imageData!)
        user.setObject(imageFile, forKey: "profilePhoto")
        user.saveInBackgroundWithBlock({ (success) -> Void in
          print("saved succesfully ")
          self.setForImage()
          self.profileImageView.image = scaledImage
        })
        UIApplication.sharedApplication().statusBarStyle = .LightContent
      }
      
      dismissViewControllerAnimated(true, completion: nil)
  }

  func setForImage() {
    print("SET FOR IMAGE")
    self.imageHeightConstraint.constant = 130
    self.imageWidthConstraint.constant = 130
    self.view.layoutSubviews()
    self.profileImageView.layer.borderWidth = 0
    self.profileImageView.layer.masksToBounds = false
    self.profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2
    self.profileImageView.clipsToBounds = true
    self.profileImageView.contentMode = UIViewContentMode.ScaleAspectFill

    self.addPhotoLabel.hidden = true

  }

  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
      dismissViewControllerAnimated(true, completion: nil)
  }

  func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size

    let widthRatio  = targetSize.width  / image.size.width
    let heightRatio = targetSize.height / image.size.height

    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
      newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
    } else {
      newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
    }

    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRectMake(0, 0, newSize.width, newSize.height)

    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.drawInRect(rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return newImage
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }

//  // MARK: CardIO Delegate Methods
//  func userDidCancelPaymentViewController(paymentViewController: CardIOPaymentViewController!) {
//      
//      println("user cancelled payment!!")
//     // scanVC.dismissViewControllerAnimated(true, completion: nil)
//      
//  }
//
//  func userDidProvideCreditCardInfo(cardInfo: CardIOCreditCardInfo!, inPaymentViewController paymentViewController: CardIOPaymentViewController!) {
//      println("received card info! number: \(cardInfo.redactedCardNumber)")
//      scanVC.dismissViewControllerAnimated(true, completion: nil)
//  }

  @IBAction func tappedChangePassword(sender: AnyObject) {
  }
  @IBAction func tappedLogout(sender: AnyObject) {
    PFUser.logOut()
    SVProgressHUD.show()

    let vc : OnboardViewController = self.storyboard!.instantiateViewControllerWithIdentifier("onboardController") as! OnboardViewController
    
    let app : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    SVProgressHUD.dismiss()
    
    app.window!.rootViewController = vc
  }

  @IBAction func editPaymentTapped(sender: AnyObject) {
     // self.presentViewController(scanVC, animated: true, completion: nil)
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
