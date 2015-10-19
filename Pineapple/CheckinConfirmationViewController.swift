//
//  CheckinConfirmationViewController.swift
//  Pineapple
//
//  Created by Valentin Perez on 6/3/15.
//  Copyright (c) 2015 Valpe Technologies. All rights reserved.
//

import UIKit
import MapKit
import Parse

class CheckinConfirmationViewController: UIViewController {

  internal var beforeVC : UIViewController!
  internal var hoursStaying = 2

  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet var mapView: MKMapView!
  var locationManager = CLLocationManager()
  let regionRadius: CLLocationDistance = 200

  var placeName : String = ""
  var placeObject : PFObject!

  override func viewDidLoad() {
    super.viewDidLoad()

    UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default

//    print("place object: \(placeObject)")
//    let placeLocation : PFGeoPoint = placeObject["location"] as! PFGeoPoint
//    //let placeName = placeObject["name"] as! String
//    let placeDescription = "Get directions"//placeObject["description"] as! String
//
//    let placePin = PlaceAnnotation(title: placeName,
//      description: placeDescription,
//      coordinate: CLLocationCoordinate2D(latitude: placeLocation.latitude, longitude: placeLocation.longitude))
//
//    mapView.addAnnotation(placePin)
//    mapView.delegate = self
  }

  override func viewDidDisappear(animated: Bool) {
    UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent

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

   // var placePin = MKMapPoint(x: 70, y: 90)

    mapView.setRegion(coordinateRegion, animated: true)
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

  @IBAction func tappedGetDirections(sender: AnyObject) {
   // var latitute:CLLocationDegrees = placeObject["location"]
    //var longitute:CLLocationDegrees =  lng1.doubleValue

    let geoPoint = placeObject["location"] as? PFGeoPoint
    //let userLoc = CLLocation(latitude: geoPoint!.latitude, longitude: geoPoint!.longitude)

    let coord2D = CLLocationCoordinate2D(latitude: geoPoint!.latitude, longitude: geoPoint!.longitude)

    let regionDistance:CLLocationDistance = 10000
    //var coordinates = CLLocationCoordinate2DMake(latitute, longitute)
    let regionSpan = MKCoordinateRegionMakeWithDistance(coord2D, regionDistance, regionDistance)
    let options = [
      MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
      MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
    ]
    let placemark = MKPlacemark(coordinate: coord2D, addressDictionary: nil)
    let mapItem = MKMapItem(placemark: placemark)

    let placeName = placeObject["name"] as! String
    mapItem.name = placeName
    mapItem.openInMapsWithLaunchOptions(options)
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




extension CheckinConfirmationViewController: MKMapViewDelegate {


  func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
    if let annotation = annotation as? PlaceAnnotation {
      let identifier = "pin"
      var view: MKPinAnnotationView
      if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        as? MKPinAnnotationView { // 2
          dequeuedView.annotation = annotation
          view = dequeuedView
      } else {
        // 3
        view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        view.canShowCallout = true
        view.calloutOffset = CGPoint(x: -5, y: 5)
        view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
      }
      return view
    }
    return nil
  }

  func mapView(mapView: MKMapView, annotationView view: MKAnnotationView,
    calloutAccessoryControlTapped control: UIControl) {
      let location = view.annotation as! PlaceAnnotation
      let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
      location.mapItem().openInMapsWithLaunchOptions(launchOptions)
  }
  
}

