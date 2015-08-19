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

class DiscoverViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource  {
    
    var placeNames: [String] = ["Ritz Carlton", "Nizuc", "Aqua", "Riu Palace", "Le Blanc", "Mayakoba", "JW Marriot", "Oasis Cancun", "Omni Hotel", "Dreams"]
    
    var places : [PFObject] = []
    
    var sunnyRefresher : YALSunnyRefreshControl!
    var refreshing = false
    
    @IBOutlet var tableView: UITableView!
    
  override func viewDidLoad() {
    super.viewDidLoad()

    println("DISCOVER")

    sunnyRefresher  = YALSunnyRefreshControl.attachToScrollView(self.tableView, target: self, refreshAction: "didStartRefreshAnimation")

    self.tableView.delegate = self
    self.tableView.dataSource = self


    refreshPlaces()

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
        println("REFRESHING YOO")
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
      println("PLACES: \(self.places.count)")

      if (self.places.count <= 0) {
        println("REFRESHING AGAIN")
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

      var cell : PlaceTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("placeCell") as! PlaceTableViewCell
      
      
      //cell.imageView?.image = UIImage(named: self.imageNames[indexPath.row])

      if (self.places.count > indexPath.row) {
        var place = PFObject(className:"Place")
        place = self.places[indexPath.row]
        
        cell.placeName?.text = place["name"] as? String
        cell.placeDescription?.text = place["description"] as? String
        cell.placePrice?.text = place["price"] as? String
        cell.placeCity?.text = place["city"] as? String
        
        let imageFile = place["image"] as? PFFile
        let url = imageFile!.url
        
        cell.placeImage!.setImageWithURL(NSURL(string: url!), placeholderImage: UIImage(named: "nizuc-beach.jpg"))
      }

//      } else {
//          cell.placeName?.text = self.placeNames[indexPath.row]
//          cell.placeDescription?.text = "Pool, beach, and gym."
//          cell.placeImage?.image = UIImage(named: "nizuc-beach.jpg")
//      }
//
      cell.clipsToBounds = true

      return cell
    }

    @IBAction func unwindToMainViewController (sender: UIStoryboardSegue){
        // bug? exit segue doesn't dismiss so we do it manually...
      self.dismissViewControllerAnimated(true, completion: nil)
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 158
    }

    func refreshPlaces() {

      println("trynna refresh")

        if (!self.refreshing) {
          self.refreshing = true
          var query = PFQuery(className:"Place")

          let user = PFUser.currentUser()!
          PFGeoPoint.geoPointForCurrentLocationInBackground {
            (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
            if error == nil {
              query.whereKey("location", nearGeoPoint: geoPoint!)
              query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]?, error: NSError?) -> Void in
                self.stopRefreshing()

                if error == nil {
                  // The find succeeded.
                  println("Successfully retrieved \(objects!.count) places.")
                  // Do something with the found objects
                  if let objects = objects as? [PFObject] {
                    self.places = objects

                    for object in objects {
                      println(object.objectId)
                    }
                  }
                } else {
                  // Log details of the failure
                  println("Error: \(error!) \(error!.userInfo!)")
                }
                self.tableView.reloadData()
              }
            }
          }

        }

    }

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    let vc : DetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("detailController") as! DetailViewController
    
//        vc.descriptionString = moreDescriptions[indexPath.row]
//        vc.buttonTitle = buttonTitles[indexPath.row]
//        vc.actionURL = actionURLs[indexPath.row]
//
    
     if (self.places.count > indexPath.row) {
        var placeSelected = PFObject(className:"Place")
        placeSelected = self.places[indexPath.row]


      println("PLACE TAPPED: \(placeSelected)")
      if placeSelected["available"] as! Bool == false {
        println("PLACE UNAVAILABLE")


      }
        vc.placeObject = placeSelected
     }

    self.navigationController?.pushViewController(vc, animated: true);
    
    //self.presentViewController(vc, animated: true, completion: nil)
    
    println("clickedbrah")

    tableView.cellForRowAtIndexPath(indexPath)?.selected = false
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
        
        
        //rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, 45.0 * M_PI / 180.0, 0.0, 1.0, 0.0)
        
        
        
        
        cell.layer.transform = rotationAndPerspectiveTransform;
        
//        
//        //var rotation : CATransform3D
//
//        //rotation = CATransform3DMakeRotation((90.0*3.14159)/180, 0.0, 0.7, 0.4)
//
//        //rotation.m34 = 1.0/(-600)
//        cell.layer.shadowColor = UIColor.blackColor().CGColor
//        cell.layer.shadowOffset = CGSizeMake(10, 10)
//        cell.alpha = 0
//        
//    
//        //cell.layer.transform = rotation
//        cell.layer.anchorPoint = CGPointMake(0.5, 0.5)
//        
//        UIView.beginAnimations("rotation", context: nil)
//        UIView.setAnimationDuration(0.3)
//        
//        cell.layer.transform = CATransform3DIdentity
//        cell.alpha = 1
//        cell.layer.shadowOffset = CGSizeMake(0, 0)
        UIView.commitAnimations()
        
    }

    
  func scrollViewDidScroll(scrollView: UIScrollView) {

    var translation : CGPoint = scrollView.panGestureRecognizer.translationInView(scrollView.superview!)


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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
    }
    

}
