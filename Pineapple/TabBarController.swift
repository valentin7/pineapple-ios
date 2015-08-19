//
//  TabBarController.swift
//  Pineapple
//
//  Created by Valentin Perez on 7/11/15.
//  Copyright (c) 2015 Valpe Technologies. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

      self.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
      self.title = nil;
        // Do any additional setup after loading the view.
    }

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
