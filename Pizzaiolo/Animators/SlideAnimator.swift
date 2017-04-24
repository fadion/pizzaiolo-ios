//
//  SlideAnimator.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 27/03/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import UIKit

/*
 Based on the implementation from AppCoda
 https://www.appcoda.com/slide-down-menu-swift/
 */

class SlideAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
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
        
        var moveDownY = container.frame.height
        if UIDevice.current.orientation == .portrait {
            moveDownY -= 150
        }
        
        let moveDown = CGAffineTransform(translationX: 0, y: moveDownY)
        
        if self.isPresenting {
            SlideAnimator.snapshot = fromView.snapshotView(afterScreenUpdates: true)
            SlideAnimator.snapshot?.layer.shadowPath = UIBezierPath(rect: SlideAnimator.snapshot!.bounds).cgPath
            SlideAnimator.snapshot?.layer.shadowColor = UIColor.black.cgColor
            SlideAnimator.snapshot?.layer.shadowRadius = 15.0
            SlideAnimator.snapshot?.layer.shadowOpacity = 0.2
            
            container.addSubview(toView)
            container.addSubview(SlideAnimator.snapshot!)
        }
        
        UIView.animate(withDuration: self.duration, delay: 0, options: [.curveEaseInOut], animations: {
            if self.isPresenting {
                SlideAnimator.snapshot?.transform = moveDown
            }
            else {
                SlideAnimator.snapshot?.transform = CGAffineTransform(translationX: 0, y: 0)
            }
        }, completion: { _ in
            transitionContext.completeTransition(true)
            
            if !self.isPresenting {
                SlideAnimator.snapshot?.removeFromSuperview()
            }
        })
    }
    
}

extension SlideAnimator: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresenting = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresenting = false
        return self
    }
    
}
