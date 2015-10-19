//
//  DiscoverViewController.swift
//  Pineapple
//
//  Created by Valentin Perez on 5/22/15.
//  Copyright (c) 2015 Valpe Technologies. All rights reserved.
//

import UIKit
import Parse
import AFNetworking
import Mixpanel

class DiscoverViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource, OptionsViewControllerDelegate  {
    
  var placeNames: [String] = ["Ritz Carlton", "Nizuc", "Aqua", "Riu Palace", "Le Blanc", "Mayakoba", "JW Marriot", "Oasis Cancun", "Omni Hotel", "Dreams"]
  
  var places : [PFObject] = []
  var placeToShow : PFObject!
  let kNearby : String = "Nearest"
  var cityId : String = "Nearest"
  var locationOptions : [PFObject] = []


  var sunnyRefresher : YALSunnyRefreshControl!
  var refreshing = false

  var mixPanel : Mixpanel!
  var user : PFUser!

  @IBOutlet var locationOptionsButton: UIBarButtonItem!

  @IBOutlet var tableView: UITableView!
    
  override func viewDidLoad() {
    super.viewDidLoad()

    print("DISCOVER")
    locationOptionsButton.title = cityId


    sunnyRefresher  = YALSunnyRefreshControl.attachToScrollView(self.tableView, target: self, refreshAction: "didStartRefreshAnimation")

    self.tableView.delegate = self
    self.tableView.dataSource = self

    user = PFUser.currentUser()

    mixPanel = Mixpanel.sharedInstance()

    refreshPlaces()
    getLocationOptions()

    
    //UIBarButtonItem.appearanceWhenContainedInInstancesOfClasses([UINavigationBar.self]).
    let font = UIFont(name: "HelveticaNeue-Thin", size: 14) as! AnyObject
    locationOptionsButton.setTitleTextAttributes([NSFontAttributeName: font
], forState: UIControlState.Normal)



    //UIBarButtonItem.appearance().setBackButtonBackgroundImage(UIImage(named: "back")
    //, forState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
    self.navigationItem.title = ""
    self.navigationController?.navigationItem.title = ""
    self.navigationItem.backBarButtonItem?.title = ""
    self.navigationController?.navigationItem.backBarButtonItem?.title = ""

    self.title = nil;

    self.navigationController?.navigationBar.topItem?.title = ""


//      [[UIBarButtonItem appearance]
//        setBackButtonBackgroundImage:[UIImage imageNamed:@"back_button.png"]
//        forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

       // self.navigationController?.hidesBarsOnSwipe = true
        
//        let testObject = PFObject(className: "TestObject")
//        testObject["foo"] = "bar"
//        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
//            println("Object has been saved.")
//        }
     

        // Do any additional setup after loading the view.
    }

  override func viewWillAppear(animated: Bool) {
    self.tabBarItem.imageInsets = UIEdgeInsetsMake(6.0, 0.0, -6.0, 0.0);
  }

  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
    func didStartRefreshAnimation (){
        print("REFRESHING YOO")
        self.refreshPlaces()
       // self.navigationController?.navigationBar.hidden = true
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
        //var timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("stopRefreshing"), userInfo: nil, repeats: false)
    }
    
    
    
    func stopRefreshing() {
        sunnyRefresher.endRefreshing()
        self.refreshing = false
    }
    
    override func viewDidAppear(animated: Bool) {
      print("PLACES: \(self.places.count)")

      if (self.places.count <= 0) {
        print("REFRESHING AGAIN")
        self.refreshPlaces()
      }
     // var tracker = GAI.sharedInstance().defaultTracker
      //tracker.set(kGAIScreenName, value: name)

      //var builder = GAIDictionaryBuilder.createScreenView()
      //tracker.send(builder.build() as [NSObject : AnyObject])
       // self.navigationController?.hidesBarsOnSwipe = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.places.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

      let cell : PlaceTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("placeCell") as! PlaceTableViewCell
      
      
      //cell.imageView?.image = UIImage(named: self.imageNames[indexPath.row])

      if (self.places.count > indexPath.row) {
        var place = PFObject(className:"Place")
        place = self.places[indexPath.row]
        
        cell.placeName?.text = place["name"] as? String
        cell.placeDescription?.text = place["description"] as? String
        cell.placePrice?.text = place["price"] as? String
        cell.placeCity?.text = place["city"] as? String

        let spotsLeft = place["spacesLeft"] as? Int

        cell.spotsLeftLabel?.text = "\(spotsLeft!) spots left"
        
        let imageFile = place["image"] as? PFFile
        let url = imageFile!.url
        print("image url: \(url!)")
        //cell.placeImage.setImageWithURL(NSURL(string: url!)!)

        //cell.placeImage.setImageWithURL(NSURL(string: url!)!, placeholderImage: UIImage(named: "nizuc-beach.jpg"))
        let imageName = place["imageName"] as! String
        print("imageName: \(imageName)")
        //cell.placeImage.image = UIImage(named: imageName)
        cell.placeImage!.setImageWithURL(NSURL(string: url!)!, placeholderImage: UIImage(named: "nizuc-beach.jpg"))
      }
      cell.clipsToBounds = true

      return cell
    }

    @IBAction func unwindToMainViewController (sender: UIStoryboardSegue){
        // bug? exit segue doesn't dismiss so we do it manually...
      self.dismissViewControllerAnimated(true, completion: nil)
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 350
    }

    func refreshPlaces() {

      print("trynna refresh")

        if (!self.refreshing) {
          self.refreshing = true

          PFGeoPoint.geoPointForCurrentLocationInBackground {
            (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
            if error == nil {
              //let query1 = PFQuery(className:"Place")
              let query2 = PFQuery(className:"Place")

              //let locationsSorted = query1.whereKey("location", nearGeoPoint: geoPoint!)
              let onlyShowing = query2.whereKey("show", equalTo: "yes")

              if (self.cityId != self.kNearby) {
                onlyShowing.whereKey("cityId", equalTo: self.cityId)
              }
              //let combined = [query1, query2]
              //let query = PFQuery.orQueryWithSubqueries(combined)

             // onlyShowing.whereKey("location", notEqualTo: "yes")


//              var sortDescriptor = NSSortDescriptor(key: "location", ascending: true, comparator: { (obj1 : AnyObject!, obj2 : AnyObject!) -> NSComparisonResult in
//                var loc1 = obj1 as! PFGeoPoint
//                var loc2 = obj2 as! PFGeoPoint
//                var distance1 = geoPoint?.distanceInKilometersTo(loc1)
//                var distance2 = geoPoint?.distanceInKilometersTo(loc2)
//                return NSComparisonResult(rawValue: Int(distance1! - distance2!))!
//              })


             // onlyShowing.orderBySortDescriptor(sortDescriptor)
              //query.whereKey("show", notEqualTo: "yes")
              //query.whereKey("toShow", equalTo: 1)

              onlyShowing.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]?, error: NSError?) -> Void in
                self.stopRefreshing()

                if error == nil {
                  // The find succeeded.
                  print("Successfully retrieved \(objects!.count) places.")
                  // Do something with the found objects

                  if let objects = objects as? [PFObject] {

                    let sorted = objects.sort({ (o1, o2) -> Bool in
                      let loc1 = o1["location"] as! PFGeoPoint
                      let loc2 = o2["location"] as! PFGeoPoint

                      let dist1 = loc1.distanceInKilometersTo(geoPoint)
                      let dist2 = loc2.distanceInKilometersTo(geoPoint)

                      return dist1 < dist2
                    })

//                    objects.sort({ (obj1, obj2) -> Bool in
//                      return false
//                    })
                    self.places = sorted

                    let temp = self.places[0]
                    let temp2 = self.places[1]
                    self.places[0] = temp2
                    self.places[1] = temp

                    PlaceManager.sharedInstance.currentPlace = self.places[0]
                   // print("meow: \(PlaceManager.sharedInstance.currentPlace)")
                  }
                } else {
                  // Log details of the failure
                  print("Error: \(error!) \(error!.userInfo)")
                }
                self.tableView.reloadData()
              }
            }
          }

        }

    }

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    //let vc : DetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("detailController") as! DetailViewController
    let vc : TweakViewController = self.storyboard?.instantiateViewControllerWithIdentifier("tweakController") as! TweakViewController

//        vc.descriptionString = moreDescriptions[indexPath.row]
//        vc.buttonTitle = buttonTitles[indexPath.row]
//        vc.actionURL = actionURLs[indexPath.row]
//
    
     if (self.places.count > indexPath.row) {
      var placeSelected = PFObject(className:"Place")

      print("PLACESSS: \(self.places)")
      placeSelected = self.places[indexPath.row]

      let placeName = placeSelected["name"] as! String
      let userName = user["name"] as! String
      let placeAvailable = placeSelected["available"] as! Bool

      var placeAvailableString = "no"
      if placeAvailable == true {
        placeAvailableString = "yes"
      }

      let info : [String: String] = ["placeName" : placeName, "userEmail" : user.email!, "nameOfUser" : userName, "placeAvailable" : placeAvailableString]

      PFAnalytics.trackEvent("tappedPlace", dimensions: info)
      mixPanel.track("tappedPlace", properties: info)

      if placeAvailable == false {
        self.showPlaceUnavailableAlert(info)
        return
      }
      print("BEFORE PUSHING NEW SCREEN:: \(placeSelected)")

      //vc.placeStringPrice = placeSelected["price"] as! String
      vc.placeStringPrice = placeSelected["price"] as! String

      vc.placeName = placeName
      vc.place = placeSelected
      vc.placePrice = 5
      vc.imageName = placeSelected["imageName"] as! String
      PlaceManager.sharedInstance.currentPlace = placeSelected
      placeToShow = placeSelected
      print("SINGLETON BEFORE AGORA: \(PlaceManager.sharedInstance.currentPlace)")


      print("suppose:: \(vc.place!)")
      self.presentViewController(vc, animated: true, completion: nil)
      //self.performSegueWithIdentifier("toTweakSegue", sender: self)
      //self.navigationController?.pushViewController(vc, animated: true);
     }

    //self.presentViewController(vc, animated: true, completion: nil)

    tableView.cellForRowAtIndexPath(indexPath)?.selected = false
  }

  func showPlaceUnavailableAlert(placeInfo : [String: String]){

    let placeName = placeInfo["placeName"]
    let title = "\(placeName!) is unavailable"

    SweetAlert().showAlert(title, subTitle: "Would you like to see \(placeName!) in Pineapple?", style: AlertStyle.Warning, buttonTitle:"No", buttonColor: UIColor.flatRedColor(), otherButtonTitle:  "Yes!", otherButtonColor: UIColor.flatMintColor()) { (isOtherButton) -> Void in
      if isOtherButton == true {
        print("DOES NOT WANT to see hotel \(placeInfo)")
        PFAnalytics.trackEvent("notWantPlace", dimensions: placeInfo)
        self.mixPanel.track("notWantPlace", properties: placeInfo)
      }
      else {
        PFAnalytics.trackEvent("wantsPlace", dimensions: placeInfo)
        self.mixPanel.track("wantsPlace", properties: placeInfo)
        SweetAlert().showAlert("Thanks!", subTitle: "If you have any other hotel recommendation, you can contact us by tapping 'Send feedback' in the profile screen.", style: AlertStyle.Success)
      }

    }

  }

    //This function is where all the table cell animations magic happens

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

        if cell.respondsToSelector("setSeparatorInset:") {
            cell.separatorInset = UIEdgeInsetsZero
        }
        if cell.respondsToSelector("setLayoutMargins:") {
            cell.layoutMargins = UIEdgeInsetsZero
        }
        if cell.respondsToSelector("setPreservesSuperviewLayoutMargins:") {
            cell.preservesSuperviewLayoutMargins = false
        }
        
        CellAnimator.animateZoom(cell)
        
        var rotationAndPerspectiveTransform : CATransform3D = CATransform3DIdentity
        rotationAndPerspectiveTransform.m34 = 1.0 / -500

        cell.layer.transform = rotationAndPerspectiveTransform;

        UIView.commitAnimations()
    }

    
  func scrollViewDidScroll(scrollView: UIScrollView) {

    let translation : CGPoint = scrollView.panGestureRecognizer.translationInView(scrollView.superview!)


    //[scrollView.panGestureRecognizer translationInView:scrollView.superview];

    if(translation.y > 0)
    {
      navigationController?.setNavigationBarHidden(false, animated: true) //or animated: false
      // react to dragging down
    } else
    {
      navigationController?.setNavigationBarHidden(true, animated: true) //or animated: false
      // react to dragging up
    }

  }

  func getLocationOptions() {
    let optionsQuery = PFQuery(className:"Cities")

    optionsQuery.findObjectsInBackgroundWithBlock { (result, error) -> Void in
      if (result == nil) {
        return
      }
      self.locationOptions = result as! [PFObject]
    }
  }


  @IBAction func tappedLocationOption(sender: AnyObject) {
    let optionVC = self.storyboard?.instantiateViewControllerWithIdentifier("locationOptionsController") as! OptionsViewController

    var options : [String] = [kNearby]

    for location in self.locationOptions {
      options.append(location["cityDisplayName"] as! String)
    }

    optionVC.options = options

    self.presentViewController(optionVC, animated: true, completion: nil)
  }

  func didChooseOption(option: Int) {
    self.cityId = self.locationOptions[option]["cityID"] as! String
    print("chosen city is: \(self.cityId)")
    self.locationOptionsButton.title = (self.locationOptions[option]["cityDisplayName"] as! String)

    self.tableView.reloadData()
  }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
      let vc : TweakViewController = segue.destinationViewController as! TweakViewController
      vc.place = placeToShow
        
        
    }
    

}
