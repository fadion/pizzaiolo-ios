//
//  PaymentController.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 03/04/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class PaymentController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var paypalButton: UIButton!
    @IBOutlet weak var creditCardButton: UIButton!
    @IBOutlet weak var applePayButton: UIButton!
    @IBOutlet weak var total: UILabel!
    
    private let disposeBag = DisposeBag()
    fileprivate let pushAnimator = PushAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupPayButtons()
        
        Cart.instance.sum()
            .map { "Total: \(Money($0).format())" }
            .bindTo(self.total.rx.text)
            .disposed(by: self.disposeBag)
    }
    
    private func setupPayButtons() {
        self.backButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.close()
        }).disposed(by: self.disposeBag)
        
        Observable.of(self.paypalButton.rx.tap, self.creditCardButton.rx.tap, self.applePayButton.rx.tap)
            .merge()
            .subscribe(onNext: { [weak self] in
                self?.placeOrder()
            }).disposed(by: self.disposeBag)
        
        self.paypalButton.layer.borderWidth = 1.0
        self.paypalButton.layer.borderColor = UIColor(hex: 0xD3D3D3)?.cgColor
        
        self.creditCardButton.layer.borderWidth = 1.0
        self.creditCardButton.layer.borderColor = UIColor(hex: 0xD3D3D3)?.cgColor
        
        self.applePayButton.layer.borderWidth = 1.0
        self.applePayButton.layer.borderColor = UIColor(hex: 0xD3D3D3)?.cgColor
    }

}

extension PaymentController {
    
    func close() {
        self.transitioningDelegate = self.pushAnimator
        self.dismiss(animated: true, completion: nil)
    }
    
    func placeOrder() {
        let alert = UIAlertController(title: "Order Placed", message: "Thank you for your order. It will be delivered to your door as soon as possible. Or not...", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            Cart.instance.clear()
            self?.close()
        })
        
        self.present(alert, animated: true)
    }
    
}
