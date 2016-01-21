//
//  AppDelegate.swift
//  Pineapple
//
//  Created by Valentin Perez on 5/21/15.
//  Copyright (c) 2015 Valpe Technologies. All rights reserved.
//

import UIKit
import Parse
import Bolts
import Stripe
import Mixpanel


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

    // [Optional] Power your app with Local Datastore. For more info, go to
    // https://parse.com/docs/ios_guide#localdatastore/iOS
    Parse.enableLocalDatastore()

    Stripe.setDefaultPublishableKey(Constants.Payment.stripePublishableKey)

    // Initialize Parse.
    Parse.setApplicationId(Constants.Parse.applicationId,
      clientKey: Constants.Parse.clientKey)

    UIApplication.sharedApplication().statusBarStyle = .LightContent

    // [Optional] Track statistics around application opens.
    PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
    //[Braintree setReturnURLScheme:@"com.your-company.Your-App.payments"];

    Mixpanel.sharedInstanceWithToken(Constants.Mixpanel.token)


    self.setTabbarWidth()
    // Braintree.setReturnURLScheme(<#scheme: String!#>)
    let currentUser = PFUser.currentUser()

    if currentUser != nil {
      // Do stuff with the user
      // normal, keep doing what you're doing bruh

    } else {
      // Show the signup or login screen
      //
//      let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//
//      let vc : OnboardViewController = mainStoryboard.instantiateViewControllerWithIdentifier("onboardController") as! OnboardViewController
//
//      self.window?.rootViewController = vc

      //LogInViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"logInController"];
      //self.window.rootViewController = vc;
    }

    return true
  }

  func setTabbarWidth() {
    let screenSize = UIScreen.mainScreen().applicationFrame
    let tabBarItemsCount : CGFloat = 2
    let width = screenSize.size.width / tabBarItemsCount
    UITabBar.appearance().itemWidth = width
  }
  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}

