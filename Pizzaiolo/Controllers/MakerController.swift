//
//  MakerController.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 21/03/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class MakerController: ViewControllerWithNavBar {

    @IBOutlet weak var scrollView: ScrollViewWithControls!
    
    private let disposeBag = DisposeBag()
    
    let contentView = UIView()
    var photo = MakerPhotoView()
    var price = Variable<Int>(MakerConfiguration.basePrice)
    var condiments = Variable<[String]>([])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupContentView()
        self.setupPhoto()
        self.setupViews()
    }
    
    private func setupContentView() {
        self.scrollView.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    private func setupPhoto() {
        self.photo = MakerPhotoView()
        
        self.price.asObservable().subscribe(onNext: { [weak self] value in
            self?.photo.addToCart.price.text = Money(value).format()
        }).disposed(by: self.disposeBag)
        
        self.photo.addToCart.button.rx.tap.asObservable().subscribe(onNext: { [weak self] in
            self?.addToCart()
        }).disposed(by: self.disposeBag)
        
        self.condiments.asObservable()
            .map { $0.isEmpty }
            .subscribe(onNext: { [weak self] empty in
                self?.photo.addToCart.isHidden = empty
            }).disposed(by: self.disposeBag)
        
        self.contentView.addSubview(self.photo)
        self.photo.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(230)
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupSectionTitle(text: String, previous: UIView) -> UILabel {
        let title = UILabel()
        title.textAlignment = .center
        title.textColor = UIColor(hex: Theme.Color.title)
        title.font = UIFont.systemFont(ofSize: Theme.Font.heading2)
        title.text = text
        
        self.contentView.addSubview(title)
        
        title.snp.makeConstraints { make in
            make.top.equalTo(previous.snp.bottom).offset(40)
            make.width.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
        }
        
        return title
    }
    
    private func setupViews() {
        var previousView: UIView = self.photo
        var i = 1
        var condimentIndex = 0
        
        for item in MakerConfiguration.layout {
            switch item["type"] as! LayoutType {
            case .title:
                previousView = self.setupSectionTitle(
                    text: item["title"] as! String,
                    previous: previousView)
            case .button:
                let condiment = MakerCondimentView(title: item["title"] as! String, price: item["price"] as! Int)
                let index = condimentIndex
                
                condiment.button.rx.tap.subscribe(onNext: { [weak self] in
                    self?.condimentSelected(
                        image: item["title"] as! String,
                        index: index,
                        price: item["price"] as! Int,
                        view: condiment)
                }).disposed(by: self.disposeBag)
                
                self.contentView.addSubview(condiment)
                
                condiment.snp.makeConstraints { make in
                    make.top.equalTo(previousView.snp.bottom).offset(10)
                    make.height.equalTo(40)
                    make.width.equalToSuperview().offset(-40)
                    make.centerX.equalToSuperview()
                }
                
                // The last view should have a bottom constraint to
                // the container for the scrollview contentsize to
                // adjust automatically.
                if i == MakerConfiguration.layout.count {
                    condiment.snp.makeConstraints { make in
                        make.bottom.equalToSuperview().offset(-20)
                    }
                }
                
                previousView = condiment
                condimentIndex += 1
            }
            
            i += 1
        }
        
        self.contentView.bringSubview(toFront: self.photo)
    }
    
    fileprivate func calculateId() -> Int {
        // Turns each condiment into a sum of it's unicode scalars
        // and finally sums up every condiment to generate a
        // unique ID for each combination.
        return self.condiments.value.map { $0.hash() }.reduce(0, +)
    }
}

extension MakerController {
    
    func condimentSelected(image: String, index: Int, price: Int, view: MakerCondimentView) {
        self.photo.toggleCondiment(image, index: index)
        view.toggleState { [unowned self] active in
            if active {
                self.price.value += price
                self.condiments.value.append(image)
            }
            else {
                self.price.value -= price
                self.condiments.value.remove(at: self.condiments.value.index(of: image)!)
            }
        }
    }
    
    func addToCart() {
        self.photo.animateAddToCartButton()
        
        let item = CartItem(
            id: self.calculateId(),
            name: "Custom Pizza",
            summary: self.condiments.value.joined(separator: ", "),
            price: self.price.value,
            photo: self.photo.renderToImage())
        
        Cart.instance.add(item: item)
    }
    
}

extension MakerController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let navigationBarHeight = self.navigationController?.navigationBar.frame.height else { return }
        
        // The scrollview is layed out below the navigation and
        // status bar. Both of their heights are added to keep
        // the photo in its correct position.
        self.photo.frame.origin.y = scrollView.contentOffset.y + navigationBarHeight + UIApplication.shared.statusBarFrame.height
        
        // Make the photo smaller. Check the height too, so the
        // animation occurrs only once.
        if scrollView.contentOffset.y > 40 && self.photo.frame.height > 180 {
            UIView.animate(withDuration: 0.3) {
                self.photo.frame.size.height = 180
                self.photo.addToCart.transform = CGAffineTransform(translationX: 0, y: -40)
            }
        }
        // Return to its default size. The check if it's greater than
        // zero prevents it from animating on the first load.
        else if scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < 40 {
            UIView.animate(withDuration: 0.3) {
                self.photo.frame.size.height = 230
                self.photo.addToCart.transform = CGAffineTransform.identity
            }
        }
    }
    
}
