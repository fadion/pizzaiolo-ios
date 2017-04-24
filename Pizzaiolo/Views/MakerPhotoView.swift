//
//  MakerPhotoView.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 22/03/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import UIKit
import SnapKit

class MakerPhotoView: UIView {
    
    var condiments: [String: UIImageView] = [:]
    var indexes: [String: Int] = [:]
    var addToCart = AddToCartView()
    
    let photo: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Pizza-Base")
        image.contentMode = .scaleAspectFit
        image.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        return image
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupViews()
    }
    
    private func setupViews() {
        self.backgroundColor = UIColor(hex: Theme.Color.background, alpha: 0.8)
        self.autoresizesSubviews = true
        
        self.addSubview(self.photo)
        self.addSubview(self.addToCart)
        
        self.addToCart.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(50)
            make.width.equalTo(120)
            make.height.equalTo(35)
            make.centerX.equalToSuperview().offset(50)
        }
    }
    
    func toggleCondiment(_ condiment: String, index: Int) {
        if self.condiments[condiment] == nil {
            self.addCondiment(condiment, index: index)
        }
        else {
            self.removeCondiment(condiment)
        }
        
        // Just to be sure that the Add To Cart button isn't
        // put to back by the condiment hierarchy.
        self.bringSubview(toFront: self.addToCart)
    }
    
    private func addCondiment(_ condiment: String, index: Int) {
        if let photo = UIImage(named: "Pizza-\(condiment)") {
            let image = UIImageView(image: photo)
            image.contentMode = .scaleAspectFit
            image.frame = self.bounds
            image.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            image.transform = CGAffineTransform(translationX: 0, y: -100)
                .concatenating(CGAffineTransform(scaleX: 3, y: 3))
            
            // The indexes array keeps a reference of the condiments'
            // indexes. That way, new condiments can be inserted above
            // or below others, keeping a correct view hierarchy.
            // If no index lower than the current exists, the condiment
            // is inserted above the base photo.
            var previousView = self.photo
            if let previous = self.indexes.filter({ $0.value < index }).sorted(by: { $0.0.value > $0.1.value }).first {
                previousView = self.condiments[previous.key]!
            }
            
            self.insertSubview(image, aboveSubview: previousView)
            
            UIView.animate(withDuration: 0.2) {
                image.alpha = 1
                image.transform = CGAffineTransform.identity
            }
            
            self.condiments[condiment] = image
            self.indexes[condiment] = index
        }
    }
    
    private func removeCondiment(_ condiment: String) {
        if let image = self.condiments[condiment] {
            UIView.animate(withDuration: 0.2, animations: {
                image.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                image.alpha = 0
            }, completion: { _ in
                self.condiments.removeValue(forKey: condiment)
                self.indexes.removeValue(forKey: condiment)
                image.removeFromSuperview()
            })
        }
    }
    
    func animateAddToCartButton() {
        let photos = self.subviews.filter { $0 is UIImageView }
        
        UIView.animateAndChain(withDuration: 0.4, delay: 0, options: [.curveEaseInOut], animations: {
            self.addToCart.button.transform = CGAffineTransform(translationX: -self.addToCart.frame.size.width + self.addToCart.button.frame.width, y: 0)
            self.addToCart.price.alpha = 0
            
            // All the condiment photos are animated in sync
            // to give the impression of a single photo.
            photos.forEach {
                $0.transform = CGAffineTransform(scaleX: 1.1, y: 1.1).concatenating(CGAffineTransform(rotationAngle: -0.1))
            }
        }, completion: nil).animate(withDuration: 0.3, delay: 0.05, options: [.curveEaseInOut], animations: {
            self.addToCart.button.transform = CGAffineTransform.identity
            self.addToCart.price.alpha = 1
            
            photos.forEach {
                $0.transform = CGAffineTransform.identity
            }
        }, completion: nil)
    }
    
    func renderToImage() -> UIImage {
        UIGraphicsBeginImageContext(self.bounds.size)
        let context = UIGraphicsGetCurrentContext()
        
        self.subviews.forEach { view in
            if view is UIImageView {
                view.layer.render(in: context!)
            }
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }

}
