//
//  LaunchScreenController.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 04/04/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import UIKit
import EasyAnimation

class LaunchController: UIViewController {

    @IBOutlet weak var peel: UIImageView!
    @IBOutlet weak var base: UIImageView!
    @IBOutlet weak var sauce: UIImageView!
    @IBOutlet weak var parmiggiano: UIImageView!
    @IBOutlet weak var salami: UIImageView!
    
    let launchAnimator = LaunchAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let moveRight = CGAffineTransform(translationX: self.view.frame.width, y: 0)
        
        self.peel.transform = moveRight
        self.salami.transform = CGAffineTransform(scaleX: 3, y: 3).concatenating(CGAffineTransform(rotationAngle: CGFloat.pi / 4))
        
        UIView.animateAndChain(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.salami.transform = CGAffineTransform.identity
        }, completion: nil).animate(withDuration: 0.4, delay: 0, options: [.curveEaseInOut], animations: {
            self.peel.transform = CGAffineTransform.identity
        }, completion: { _ in
            self.performSegue(withIdentifier: "launch", sender: self)
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "launch" {
            let vc = segue.destination
            vc.transitioningDelegate = self.launchAnimator
        }
    }

}
