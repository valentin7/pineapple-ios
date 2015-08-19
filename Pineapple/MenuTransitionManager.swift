//
//  MenuTransitionManager.swift
//  ValentinWWDC2015
//
//  Created by Valentin Perez on 4/26/15.
//  Copyright (c) 2015 Valentin Perez. All rights reserved.
//

//
//  MenuTransitionManager.swift
//  Menu
//
//  Created by Mathew Sanders on 9/7/14.
//  Copyright (c) 2014 Mat. All rights reserved.
//

import UIKit

class MenuTransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate  {
    
    private var presenting = false
    
    // MARK: UIViewControllerAnimatedTransitioning protocol methods
    
    // animate a change from one viewcontroller to another
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        // get reference to our fromView, toView and the container view that we should perform the transition in
        let container = transitionContext.containerView()
        
        // create a tuple of our screens
        let screens : (from:UIViewController, to:UIViewController) = (transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!, transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!)
        
        // assign references to our menu view controller and the 'bottom' view controller from the tuple
        // remember that our moreInfoViewController will alternate between the from and to view controller depending if we're presenting or dismissing
        let moreInfoViewController = !self.presenting ? screens.from as UIViewController : screens.to as UIViewController
        
        
        let bottomViewController = !self.presenting ? screens.to as UIViewController : screens.from as UIViewController
        
        let menuView = moreInfoViewController.view
        let bottomView = bottomViewController.view
        
        // prepare menu items to slide in
        if (self.presenting){
            self.offStageMenuController(moreInfoViewController)
        }
        
        // add the both views to our view controller
        container.addSubview(bottomView)
        container.addSubview(menuView)
        
        let duration = self.transitionDuration(transitionContext)
        
        // perform the animation!
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: nil, animations: {
            
                if (self.presenting){
                    self.onStageMenuController(moreInfoViewController) // onstage items: slide in
                }
                else {
                    self.offStageMenuController(moreInfoViewController) // offstage items: slide out
                }

            }, completion: { finished in
                
                // tell our transitionContext object that we've finished animating
                transitionContext.completeTransition(true)
                
                // bug: we have to manually add our 'to view' back http://openradar.appspot.com/radar?id=5320103646199808
                UIApplication.sharedApplication().keyWindow?.addSubview(screens.to.view)
                
        })
        
    }
    
    func offStage(amount: CGFloat) -> CGAffineTransform {
        return CGAffineTransformMakeTranslation(amount, 0)
    }
    
    func offStageMenuController(moreInfoViewController: UIViewController){
        
        moreInfoViewController.view.alpha = 0
        
        // setup paramaters for 2D transitions for animations
        let topRowOffset  :CGFloat = 300
        let middleRowOffset :CGFloat = 150
        let bottomRowOffset  :CGFloat = 50
        
       // moreInfoViewController.descriptionTextView.transform = self.offStage(-topRowOffset)
       // moreInfoViewController.actionButton.transform = self.offStage(topRowOffset)
        
//        moreInfoViewController.quotePostIcon.transform = self.offStage(-middleRowOffset)
//        moreInfoViewController.quotePostLabel.transform = self.offStage(-middleRowOffset)
//        
//        moreInfoViewController.chatPostIcon.transform = self.offStage(-bottomRowOffset)
//        moreInfoViewController.chatPostLabel.transform = self.offStage(-bottomRowOffset)
//        
//        moreInfoViewController.photoPostIcon.transform = self.offStage(topRowOffset)
//        moreInfoViewController.photoPostLabel.transform = self.offStage(topRowOffset)
//        
//        moreInfoViewController.linkPostIcon.transform = self.offStage(middleRowOffset)
//        moreInfoViewController.linkPostLabel.transform = self.offStage(middleRowOffset)
//        
//        moreInfoViewController.audioPostIcon.transform = self.offStage(bottomRowOffset)
//        moreInfoViewController.audioPostLabel.transform = self.offStage(bottomRowOffset)
        
        
        
    }
    
    func onStageMenuController(moreInfoViewController: UIViewController){
        // prepare menu to fade in
        moreInfoViewController.view.alpha = 1
        
    }
    
    // return how many seconds the transiton animation will take
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 1
    }
    
    // MARK: UIViewControllerTransitioningDelegate protocol methods
    
    // return the animator when presenting a viewcontroller
    // rememeber that an animator (or animation controller) is any object that aheres to the UIViewControllerAnimatedTransitioning protocol
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = true
        return self
    }
    
    // return the animator used when dismissing from a viewcontroller
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = false
        return self
    }
    
}
