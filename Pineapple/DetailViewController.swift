//
//  DetailViewController.swift
//  Pineapple
//
//  Created by Valentin Perez on 5/23/15.
//  Copyright (c) 2015 Valpe Technologies. All rights reserved.
//

import UIKit
//import MapboxGL
import MapKit
import AddressBook
import Parse


class DetailViewController: UIViewController {

    
    
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    var locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 200

    var placeName : String = ""
    var placeObject : PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        if (placeObject != nil) {
          print("PLACE IS NOT NIL YOO")

            descriptionLabel.text = placeObject["description"] as? String

          let placeName  = placeObject["name"] as! String
            placeNameLabel?.text = placeName
            
            
            let imageFile = placeObject["image"] as? PFFile
            let url = imageFile!.url
            
          placeImageView!.setImageWithURL(NSURL(string: url!)!)


          let placeLocation : PFGeoPoint = placeObject["location"] as! PFGeoPoint
          //let placeName = placeObject["name"] as! String
          let placeDescription = "Get directions"//placeObject["description"] as! String

          let placePin = PlaceAnnotation(title: placeName,
            description: placeDescription,
            coordinate: CLLocationCoordinate2D(latitude: placeLocation.latitude, longitude: placeLocation.longitude))

          mapView.addAnnotation(placePin)
          mapView.delegate = self
        }
        // Do any additional setup after loading the view.
    }
    
    func getLocation() {
        
      if (placeObject != nil) {
          let geoPoint = placeObject["location"] as? PFGeoPoint
          let userLoc = CLLocation(latitude: geoPoint!.latitude, longitude: geoPoint!.longitude)
          self.centerMapOnLocation(userLoc)
      } else {
          PFGeoPoint.geoPointForCurrentLocationInBackground {
              (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
              if error == nil {
                  
                  let userLoc = CLLocation(latitude: geoPoint!.latitude, longitude: geoPoint!.longitude)
                  
                  print(" user location: \n",  userLoc)
                  
                  self.centerMapOnLocation(userLoc)
                  // do something with the new geoPoint
              }
          }
          
      }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }

    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)

      let placePin = MKMapPoint(x: 70, y: 90)

        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func unwindToMainViewController (sender: UIStoryboardSegue){
        // bug? exit segue doesn't dismiss so we do it manually...
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func tappedDetails(sender: AnyObject) {
        
      let vc : TweakViewController = self.storyboard?.instantiateViewControllerWithIdentifier("tweakController") as! TweakViewController

      vc.place = self.placeObject
      vc.placeName = self.placeName

      self.presentViewController(vc, animated: true, completion: nil)
        
    }
//    func mapItem() -> MKMapItem {
//        let addressDictionary = [String(kABPersonAddressStreetKey): subtitle]
//        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
//        
//        let mapItem = MKMapItem(placemark: placemark)
//        mapItem.name = title
//        
//        return mapItem
//    }
//    
//    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!,
//        calloutAccessoryControlTapped control: UIControl!) {
//            let location = view.annotation as Artwork
//            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
//            location.mapItem().openInMapsWithLaunchOptions(launchOptions)
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
