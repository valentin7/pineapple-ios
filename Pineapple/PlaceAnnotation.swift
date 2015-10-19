//
//  PlaceAnnotation.swift
//  Pineapple
//
//  Created by Valentin Perez on 7/15/15.
//  Copyright (c) 2015 Valpe Technologies. All rights reserved.
//

import UIKit
import MapKit
import Contacts


class PlaceAnnotation: NSObject, MKAnnotation {
  let title: String?
  let placeDescription: String
  let coordinate: CLLocationCoordinate2D

  init(title: String, description: String, coordinate: CLLocationCoordinate2D) {
    self.title = title
    self.placeDescription = description
    self.coordinate = coordinate

    super.init()
  }

  var subtitle: String? {
    return self.placeDescription
  }

  //TODO: FIX MAP ITEM

  // annotation callout info button opens this mapItem in Maps app
  func mapItem() -> MKMapItem {
    //var addressDictionary = ["" : "f"] as! [String:]

    if #available(iOS 9.0, *) {
      //let addressDictionary = [String(CNPostalAddressStreetKey): subtitle]
      let addressDictionary = [CNPostalAddressStreetKey: self.placeDescription]

      let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
      //let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)//MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)

      let mapItem = MKMapItem(placemark: placemark)
      mapItem.name = title

      return mapItem
    } else {
        // Fallback on earlier versions
     // let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)//MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)

      let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)

      let mapItem = MKMapItem(placemark: placemark)
      mapItem.name = title

      return mapItem
    }


  }
}
