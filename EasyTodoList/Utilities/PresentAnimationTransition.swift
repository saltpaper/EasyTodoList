//
//  PresentAnimationTransition.swift
//  EasyTodoList
//
//  Created by DJ on 21/12/2016.
//  Copyright © 2016 DJ. All rights reserved.
//

import UIKit

class presentAnimationTransition: NSObject,UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = transitionContext.viewController(forKey: .from) //as! UINavigationController
//        let fromVC = fromNavVC.viewControllers[0] as! AddTaskViewController
        let toVC = transitionContext.viewController(forKey: .to) as! FeatureViewController
        let container = transitionContext.containerView
        
        toVC.collectionView.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        toVC.dimBackgroundView.alpha = 0.5
        container.addSubview((toVC.view)!)
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: .curveLinear, animations: {
            fromVC?.view.alpha = 0.6
//            toVC.dimBackgroundView.alpha = 0

            toVC.collectionView.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.height - TODO_Constant.changeColorControllerHeight, width: UIScreen.main.bounds.width, height: TODO_Constant.changeColorControllerHeight)
            
        }, completion: { (finish) in
            
            
            transitionContext.completeTransition(true)
        })
        
    }
    
}
