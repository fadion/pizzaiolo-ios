//
//  PushAnimator.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 03/04/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import UIKit

class PushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 0.3
    var isPresenting = true
    static var snapshot: UIView?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        let container = transitionContext.containerView
        let moveRight = CGAffineTransform(translationX: container.frame.width, y: 0)
        let moveLeft = CGAffineTransform(translationX: -container.frame.width, y: 0)
        
        if self.isPresenting {
            toView.transform = moveRight
        }
        else {
            toView.transform = moveLeft
        }
        
        container.addSubview(toView)
        
        if let snapshot = PushAnimator.snapshot {
            container.addSubview(snapshot)
        }
        
        UIView.animate(withDuration: self.duration, delay: 0, options: [.curveEaseInOut], animations: {
            if self.isPresenting {
                fromView.transform = moveLeft
                toView.transform = CGAffineTransform.identity
            }
            else {
                fromView.transform = moveRight
                toView.transform = CGAffineTransform.identity
            }
        }, completion: { _ in
            transitionContext.completeTransition(true)
            
            if let snapshot = PushAnimator.snapshot {
                toView.addSubview(snapshot)
            }
        })
    }
    
}

extension PushAnimator: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresenting = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresenting = false
        return self
    }
    
}
