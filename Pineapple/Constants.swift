//
//  Constants.swift
//  Pineapple
//
//  Created by Valentin Perez on 7/3/15.
//  Copyright (c) 2015 Valpe Technologies. All rights reserved.
//


struct Constants {
  struct Payment {
    static let appleMerchantId = "merchant.world.pineapple"
    static let backendChargeURLString = "https://pineapple-backend-node.herokuapp.com"
    static let stripePublishableKey = "pk_live_a5ezrsklCRzvzC7rvYh6TtLZ"
    static let stripeTestPublishableAPIKey = "pk_test_YX6l4l6ANO3mFRo2ILbZdiF9"
  }

  struct Parse {
    static let applicationId = "Xp50umM10YcNMNbkwHHgjuXurf8jImhGddRGjjub"
    static let clientKey = "KO0L0TIYcen481FGu2lPY1rmJCBqgtH2RIMEjyqU"
  }

  struct Path {
    static let Documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
    static let Tmp = NSTemporaryDirectory()
  }

}


