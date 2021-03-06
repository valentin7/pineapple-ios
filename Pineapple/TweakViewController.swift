//
//  TweakViewController.swift
//  Pineapple
//
//  Created by Valentin Perez on 5/23/15.
//  Copyright (c) 2015 Valpe Technologies. All rights reserved.
//

import UIKit
import Stripe
import Parse
import SVProgressHUD

class TweakViewController: PAViewController, STPCheckoutViewControllerDelegate,  PKPaymentAuthorizationViewControllerDelegate, CardIOPaymentViewControllerDelegate {

  @IBOutlet var placeNameLabel: UILabel!
  @IBOutlet var placeImageView: UIImageView!
  @IBOutlet var totalPriceLabel: UILabel!
  @IBOutlet var totalPeopleLabel: UILabel!
  @IBOutlet var timeLabel: UILabel!


  private var scanVC : CardIOPaymentViewController!

  var place : PFObject!

  var placePrice : Int!
  var totalPrice : Int!
  var placeName : String = ""
  var placeDescription : String = ""
  var placeCity : String = ""
  var customerId = "unavailable"

  var peopleInRequest : Int!
  var imageURL : String = ""
  var closeDisabled = false

    
    // create instance of our custom transition manager
    let transitionManager = MenuTransitionManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()

      let placeStringPrice = place["price"] as! String

      placeName = (place["name"] as? String)!

      self.placeNameLabel.text = placeName
      self.totalPriceLabel.text = placeStringPrice

      let imageFile = place["image"] as? PFFile
      let url = imageFile!.url
      placeImageView!.setImageWithURL(NSURL(string: url!)!)

      let s: String = (placeStringPrice as NSString).substringFromIndex(1)
      placePrice = Int(s)

      placeDescription = (place["description"] as? String)!
      placeCity = (place["city"] as? String)!

      totalPrice = placePrice
      peopleInRequest = 1

      self.transitioningDelegate = self.transitionManager
      scanVC = CardIOPaymentViewController(paymentDelegate: self)

    }
    
    override func viewWillAppear(animated: Bool) {

    }

  func processPayment() {
    if let paymentRequest = Stripe.paymentRequestWithMerchantIdentifier(Constants.Payment.appleMerchantId) {
      print("in here")
      let decimalPrice = "\(totalPrice).00"
      let labelDescription = "\(placeName) in \(placeCity)"

      if Stripe.canSubmitPaymentRequest(paymentRequest) {
        print("can submit payment")
        paymentRequest.paymentSummaryItems = [PKPaymentSummaryItem(label: labelDescription, amount: NSDecimalNumber(string: decimalPrice))]
        let paymentAuthVC = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
        paymentAuthVC.delegate = self
        presentViewController(paymentAuthVC, animated: true, completion: nil)
        return
      } else {

        self.inProgressMode()

        let query = PFQuery(className: "StripeCustomer")
        let email = user?.email
        query.whereKey("userEmail", equalTo: email!)

        query.getFirstObjectInBackgroundWithBlock {
          (customer: PFObject?, error: NSError?) -> Void in
          self.finishProgressMode()

          if error != nil || customer == nil {
            print("The getFirstObject request failed.")
            self.customerId = "unavailable"
            self.presentViewController(self.scanVC, animated: true, completion: nil)

          } else {
            // The find succeeded.
            print("Successfully retrieved the StripeCustomer: \(customer).")
            if let  customerIdRetrieved = customer?.objectForKey("customerId") as? NSString {

              print("customerId: \(customerIdRetrieved)")
              self.customerId = customerIdRetrieved as String
              self.createBackendChargeWithCustomerId()

            } else {
              self.customerId = "unavailable"
              self.presentViewController(self.scanVC, animated: true, completion: nil)
            }
          }
        }


//        var query = PFQuery(className:"Place")
//
//        query.whereKey("available", equalTo:true)
//
//        query.findObjectsInBackgroundWithBlock {
//          (objects: [AnyObject]?, error: NSError?) -> Void in
//          if error == nil {
//            // The find succeeded.
//            println("Successfully retrieved \(objects!.count) places.")
//            // Do something with the found objects
//            if let objects = objects as? [PFObject] {
//
//              for object in objects {
//                println(object.objectId)
//              }
//            }
//          } else {
//            // Log details of the failure
//            println("Error: \(error!) \(error!.userInfo!)")
//          }


        print("can't use apple pay dude!!")
      }
    }
  }


    func checkoutController(controller: STPCheckoutViewController, didCreateToken token: STPToken, completion: STPTokenSubmissionHandler) {
      createBackendChargeWithToken(token, completion: completion)
    }

  func createBackendChargeWithCustomerId() {
    self.inProgressMode()

    let amount = totalPrice * 100

    let placePDescription = "\(placeName) at \(placeCity)"

    let customerName = user["name"] as! String


    if let url = NSURL(string: Constants.Payment.backendChargeURLString  + "/charge") {
      print("customer id charging: \(customerId)")
      let chargeParams : [String: AnyObject!] = ["stripeToken": "unavailable", "amount": amount, "userEmail" : user?.email!, "customerId" : customerId, "placeDescription": placeDescription, "customerName" : customerName]

      let request = NSMutableURLRequest(URL: url)

      request.HTTPMethod = "POST"
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      request.setValue("application/json", forHTTPHeaderField: "Accept")

      var error: NSError?
      do {
        request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(chargeParams, options: NSJSONWritingOptions())
      } catch let error1 as NSError {
        error = error1
        request.HTTPBody = nil
      }

      NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
        self.finishProgressMode()

        if (error != nil) {
          print("Aw: \(error)")
        } else {
          print("response: \(response)")
          if let httpResponse = response as? NSHTTPURLResponse {
            print("error \(httpResponse.description)")
            let statusCode = httpResponse.statusCode
            print("STATUS CODE: \(statusCode)")
            if statusCode == 402 {
              self.showAlertWithText("Make sure your credit card info matches your Pineapple account.", title: "Credit card rejected")
            } else {
              self.updateGuests(self.peopleInRequest)
              self.showConfirmationController()
            }

//            switch statusCode {
//            case 402 : self.showAlertWithText("Make sure your credit card info matches your Pineapple account.", title: "Credit card rejected")
//            case 500 : self.showAlertWithText("Please double check your info.", title: "There was an error with your card")
//            case 200 :
//              println("a goood YASSS")
//
//            default : self.showAlertWithText("You weren't charged. Please check your info is correct.", title: "There was an error with your request")
//            }
          }
        }
      }
      return
    } else {
      self.finishProgressMode()
    }
  }

  func createBackendChargeWithToken(token: STPToken, completion: STPTokenSubmissionHandler) {
    let amount = totalPrice * 100
    print("USER'S EMAIL: \(user?.email)")
    print("CREATING BACKEND CHARGE with token: \(token.tokenId)")
    let placePDescription = "\(placeName) at \(placeCity)"

    if let url = NSURL(string: Constants.Payment.backendChargeURLString  + "/charge") {
      let chargeParams : [String: AnyObject!] = ["stripeToken": token.tokenId, "amount": amount, "userEmail" : user?.email!, "customerId" : customerId, "placeDescription" : placePDescription, "customerName" : user["name"] ]

      let request = NSMutableURLRequest(URL: url)
      request.HTTPMethod = "POST"
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      request.setValue("application/json", forHTTPHeaderField: "Accept")

      var error: NSError?
      do {
        request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(chargeParams, options: NSJSONWritingOptions())
      } catch let error1 as NSError {
        error = error1
        request.HTTPBody = nil
      }

      self.inProgressMode()

      NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
        self.finishProgressMode()

        if (error != nil) {
          print("Aw: \(error)")
          completion(STPBackendChargeResult.Failure, error)
          self.showAlertPaymentError()
        } else {
          print("YASSSS TRYING TO SHOW CONFIRMATION")
          print("response: \(response)")
          completion(STPBackendChargeResult.Success, nil)
        }
      }
      return
    }
    completion(STPBackendChargeResult.Failure, NSError(domain: StripeDomain, code: 50, userInfo: [NSLocalizedDescriptionKey: "You created a token! Its value is \(token.tokenId). Now configure your backend to accept this token and complete a charge."]))
  }


  func checkoutController(controller: STPCheckoutViewController, didFinishWithStatus status: STPPaymentStatus, error: NSError?) {
    dismissViewControllerAnimated(true, completion: {
      switch(status) {
      case .UserCancelled:
        return // just do nothing in this case
      case .Success:
        print("great success!")
      case .Error:
        print("oh no, an error: \(error?.localizedDescription)")
      }
    })
  }

  func paymentAuthorizationViewController(controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: ((PKPaymentAuthorizationStatus) -> Void)) {
    print("payment authorization vc")
    let apiClient = STPAPIClient(publishableKey: Constants.Payment.stripePublishableKey)

    self.inProgressMode()

    apiClient.createTokenWithPayment(payment, completion: { (token, error) -> Void in
      self.finishProgressMode()
      if error == nil {
        print("no error creating token")
        if let token = token {
          self.createBackendChargeWithToken(token, completion: { (result, error) -> Void in
            if result == STPBackendChargeResult.Success {
              completion(PKPaymentAuthorizationStatus.Success)
            }
            else {
              completion(PKPaymentAuthorizationStatus.Failure)
            }
          })
        }
      }
      else {
        completion(PKPaymentAuthorizationStatus.Failure)
      }
    })
  }

  func paymentAuthorizationViewControllerDidFinish(controller: PKPaymentAuthorizationViewController) {
    dismissViewControllerAnimated(true, completion: { () -> Void in
      print("HIDING APPLE PAY")
      self.updateGuests(self.peopleInRequest)
      self.showConfirmationController()
    })

  }


 //   }

//    PKPaymentRequest *request = [Stripe
//      paymentRequestWithMerchantIdentifier:YOUR_APPLE_MERCHANT_ID];
//    // Configure your request here.
//    NSString *label = @"Premium Llama Food";
//    NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithString:@"10.00"];
//    request.paymentSummaryItems = @[
//    [PKPaymentSummaryItem summaryItemWithLabel:label
//    amount:amount]
//    ];
//
//    if ([Stripe canSubmitPaymentRequest:request]) {
//      ...
//    } else {
//      // Show the user your own credit card form (see options 2 or 3)
//    }
//
  // MARK: CardIO Delegate Methods
  func userDidCancelPaymentViewController(paymentViewController: CardIOPaymentViewController!) {

    print("user cancelled payment!!")
    scanVC.dismissViewControllerAnimated(true, completion: nil)
  }

  func userDidProvideCreditCardInfo(cardInfo: CardIOCreditCardInfo!, inPaymentViewController paymentViewController: CardIOPaymentViewController!) {
    print("received card info! number: \(cardInfo.cardNumber)")
    scanVC.dismissViewControllerAnimated(true, completion: nil)

    let customerName = user["name"] as! String
    let card = STPCard()
    card.name = customerName
    card.number = cardInfo.cardNumber
    card.expMonth = cardInfo.expiryMonth
    card.expYear = cardInfo.expiryYear
    card.cvc = cardInfo.cvv

    self.payWithCard(card)
  }

  func payWithCard(card : STPCard) {
    self.inProgressMode()
    STPAPIClient.sharedClient().createTokenWithCard(card, completion: { (token, error) -> Void in
      print("ERROR STATUS: \(error)")
      self.finishProgressMode()
      if (error == nil) {
        self.createBackendChargeWithToken(token!, completion: { (result, error) -> Void in
          if result == STPBackendChargeResult.Success {
            print("SUCCESFUL DAWGG")
            self.updateGuests(self.peopleInRequest)
            self.showConfirmationController()
            // completion(PKPaymentAuthorizationStatus.Success)
          }
          else {
            print("FAILURE DAWGG")
            // completion(PKPaymentAuthorizationStatus.Failure)
          }
        })
      } else {
        print("not nil and \(error)")
       self.showAlertPaymentError()
      }
    })
  }

  func showAlertPaymentError() {
    let alertController = UIAlertController(title: "Payment Unsuccessful", message: "Please check your payment information.", preferredStyle: .Alert)
    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
    }
    alertController.addAction(OKAction)
    self.presentViewController(alertController, animated: true, completion: nil)
  }

  func showConfirmationController () {
    let vc : CheckinConfirmationViewController = self.storyboard!.instantiateViewControllerWithIdentifier("checkinConfirmationController") as! CheckinConfirmationViewController
        vc.beforeVC = self

        self.presentViewController(vc, animated: true, completion: nil)
  }

  func inProgressMode() {
    SVProgressHUD.show()

    for view in self.view.subviews {
      if let realView = view as? UIView {
        realView.userInteractionEnabled = false
      }
    }

    self.closeDisabled = true
  }
  func finishProgressMode() {
    SVProgressHUD.dismiss()
    for view in self.view.subviews {
      if let realView = view as? UIView {
        realView.userInteractionEnabled = true
      }
    }
   // self.closeDisabled = false
  }
// MARK: IBActions
  @IBAction func tappedClose(sender: AnyObject) {
    //if (!self.closeDisabled) {
      self.dismissViewControllerAnimated(true, completion: nil)
   // }
  }

  @IBAction func changedStepper(sender: AnyObject) {
    let stepper : UIStepper = sender as! UIStepper
    
    totalPeopleLabel.text = "\(Int(stepper.value))"
    peopleInRequest = Int(stepper.value)
    
    let totalPriceCalculation = Int(stepper.value) * placePrice
    print("totalPrice calculation: \(totalPriceCalculation)")

    totalPriceLabel.text = "$\(Int(totalPriceCalculation))"
    self.totalPrice = totalPriceCalculation
  }


  @IBAction func timeSliderChanged(sender: AnyObject) {
      
      let slider : UISlider = sender as! UISlider
      let timeValue : Int = Int(slider.value)
      
      print("timevalue: "); print(timeValue, terminator: "")
      
      var timeDescription : String = "\(Int(timeValue)) min"

    switch timeValue {
      case 0: timeDescription = "5 min"
      case 1: timeDescription = "20 min"
      case 2: timeDescription = "1 hour"
      case 3: timeDescription = "2 hours"
      case 4: timeDescription = "3 hours or later"
      default: timeDescription = "20 min"
    }

//
//        if (timeValue < 60) {
//            timeValue = Int(timeValue/5) * 5
//            timeDescription = "\(Int(timeValue)) min"
//        } else {
//            var hours = timeValue/60
//            
//            if (Int(hours) == 1 ) {
//                timeDescription = "\(Int(hours)) hour"
//
//            } else {
//                timeDescription = "\(Int(hours)) hours"
//            }
//            
//        }

      
      timeLabel.text = timeDescription

          //String(format: "\n min", timeValue)
      
  }


  @IBAction func tappedGo(sender: AnyObject) {
    print("PROCESSING...")

    if self.spaceAvailable() {
      processPayment()
    }
  }

  func spaceAvailable() -> Bool {
    let numberOfCurrentGuests =  place["currentGuestsNumber"] as! Int
    let maxNumberOfGuests = place["maxGuests"] as! Int

    if (numberOfCurrentGuests + peopleInRequest > maxNumberOfGuests) {
      if (peopleInRequest <= 1) {
        self.showAlertWithText("Please check back later!", title: "\(placeName) is full")
      } else {
        self.showAlertWithText("Please try with less guests or check back later!", title: "\(placeName) is full")
      }
      return false
    }
    return true
  }


  func updateGuests(number : Int) {
    var newGuests = place["currentGuestsNumber"] as! Int
    newGuests += number
    place["currentGuestsNumber"] = newGuests
    place.saveInBackground()
  }


}
