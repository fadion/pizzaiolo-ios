//
//  LaunchAnimator.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 04/04/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import UIKit

class LaunchAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 0.5
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        let container = transitionContext.containerView
        
        container.addSubview(toView)
        container.bringSubview(toFront: fromView)
        
        UIView.animate(withDuration: self.duration, delay: 0, options: [.curveEaseInOut], animations: {
            fromView.layer.cornerRadius = (CGFloat.pi * fromView.layer.frame.width) / 3
            fromView.transform = CGAffineTransform(translationX: container.frame.width, y: 0)
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
    
}

extension LaunchAnimator: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
}
