//
//  DismissAnimationTransition.swift
//  EasyTodoList
//
//  Created by DJ on 21/12/2016.
//  Copyright © 2016 DJ. All rights reserved.
//

import UIKit

class DismissAnimationTransition: NSObject,UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = transitionContext.viewController(forKey: .from) as! FeatureViewController

        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: .curveLinear, animations: {
            fromVC.dimBackgroundView.alpha = 0.0

            fromVC.collectionView.frame.origin.y = UIScreen.main.bounds.height
            
        }, completion: { (finish) in
            
            transitionContext.completeTransition(true)
        })
        
    }

}
