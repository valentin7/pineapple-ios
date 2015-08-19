//
//  CellAnimator.swift
//  Pineapple
//
//  Created by Valentin Perez on 5/24/15.
//  Copyright (c) 2015 Valpe Technologies. All rights reserved.
//

import UIKit
import QuartzCore

let cellZoomXScaleFactor = 1.3
let cellZoomYScaleFactor = 1.3

let TipInCellAnimatorStartTransform:CATransform3D = {
    let rotationDegrees: CGFloat = 0.0
    let rotationRadians: CGFloat = rotationDegrees * (CGFloat(M_PI)/180.0)
    let offset = CGPointMake(0, -30)
    var startTransform = CATransform3DIdentity
    startTransform = CATransform3DRotate(CATransform3DIdentity,
        rotationRadians, 0.0, 0.0, 1.0)
    startTransform = CATransform3DTranslate(startTransform, offset.x, offset.y, 0.0)

    return startTransform
    }()

class CellAnimator {
    class func animate(cell:UITableViewCell) {
        let view = cell.contentView
        
        view.layer.transform = TipInCellAnimatorStartTransform
        view.layer.opacity = 0.5
        //view.layer.bounds.size = CGSize(width: view.layer.bounds.width+50, height: view.layer.bounds.height+50)
        
        
        
        UIView.animateWithDuration(0.4) {
            view.layer.transform = CATransform3DIdentity
            view.layer.opacity = 1
           // view.layer.bounds.size = CGSize(width: view.layer.bounds.width-5, height: view.layer.bounds.height-5)
        }
    }
    
    class func animateZoom(cell: UITableViewCell) {
        //now make the image view a bit bigger, so we can do a zoomout effect when it becomes visible
        cell.contentView.alpha = 0.4;
        
        var transformScale : CGAffineTransform = CGAffineTransformMakeScale(1.2, 1.2)
        
        var transformTranslate : CGAffineTransform = CGAffineTransformMakeTranslation(0,0)
        
        cell.contentView.transform = CGAffineTransformConcat(transformScale, transformTranslate);
        
        //[self.tableView bringSubviewToFront:cell.contentView];

        UIView.animateWithDuration(0.4, delay:0, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
            cell.contentView.alpha = 1
            cell.contentView.transform = CGAffineTransformIdentity
            
        }, completion: nil)
        
    }
}