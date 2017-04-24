//
//  ViewControllerWithNavBar.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 18/03/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewControllerWithNavBar: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let slideAnimator = SlideAnimator()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Cart.instance.count()
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] count in
                let button = (count > 0) ? UIBarButtonItem(badge: String(count), image: UIImage(named: "Cart")!, target: self, action: #selector(self?.showCart)) : nil
                
                self?.navigationItem.rightBarButtonItem = button
            })
            .disposed(by: self.disposeBag)
    }
    
    func showCart(sender: UIButton) {
        let cartController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cart-controller") as! CartController
        
        cartController.transitioningDelegate = self.slideAnimator
        
        self.present(cartController, animated: true)
    }

}
