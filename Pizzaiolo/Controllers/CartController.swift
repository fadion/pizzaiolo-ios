//
//  CartController.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 25/03/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class CartController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var totals: UILabel!
    
    private let disposeBag = DisposeBag()
    fileprivate let slideAnimator = SlideAnimator()
    fileprivate let pushAnimator = PushAnimator()
    
    let dataSource = RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String, CartItem>>()
    
    private var emptyCartView: PaddedLabel {
        let label = PaddedLabel()
        
        label.font = UIFont.systemFont(ofSize: Theme.Font.body)
        label.textColor = UIColor(hex: Theme.Color.light)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.sizeToFit()
        label.text = "Don't you like our pizzas? Then start adding some!"
        
        return label
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTable()
        
        // Convert count to a Bool so it can show/hide
        // the Pay button and background view.
        Cart.instance.count()
            .map { $0 > 0 }
            .subscribe(onNext: { [weak self] hasItems in
                self?.payButton.isHidden = !hasItems
                self?.tableView.backgroundView = hasItems ? nil : self?.emptyCartView
                
                if !hasItems {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self?.close()
                    }
                }
            }).disposed(by: self.disposeBag)
        
        // Combine the count and sum to show them as
        // as single string.
        Observable.zip(Cart.instance.count(), Cart.instance.sum()) {
                return ($0, $1)
            }.subscribe(onNext: { [weak self] count, sum in
                self?.totals.text = "\(count) pizza\(count != 1 ? "s" : ""): \(Money(sum).format())"
            }).disposed(by: self.disposeBag)
        
        self.closeButton.rx.tap.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.close()
            }).disposed(by: self.disposeBag)
    }
    
    private func setupTable() {
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80
        
        self.dataSource.animationConfiguration = AnimationConfiguration(insertAnimation: .top, reloadAnimation: .fade, deleteAnimation: .bottom)
        
        self.dataSource.canEditRowAtIndexPath = { _ in
            return true
        }
        
        self.tableView.rx.itemDeleted.asObservable()
            .subscribe(onNext: { [weak self] indexPath in
                self?.removeItem(indexPath: indexPath)
            }).disposed(by: self.disposeBag)
        
        self.dataSource.configureCell = { [weak self] ds, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cart", for: indexPath) as! CartTableCell
            cell.item = item
            
            cell.quantityUp.rx.tap.subscribe(onNext: { [weak self] in
                self?.incrementQuantity(item: item)
            }).disposed(by: cell.disposeBag)
            
            cell.quantityDown.rx.tap.subscribe(onNext: { [weak self] in
                self?.decrementQuantity(item: item)
            }).disposed(by: cell.disposeBag)
            
            return cell
        }
        
        Cart.instance.contents()
            .flatMap {
                Observable.just([AnimatableSectionModel(model: "cart", items: $0)])
            }
            .bindTo(self.tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "payment" {
            PushAnimator.snapshot = SlideAnimator.snapshot
            
            let vc = segue.destination
            vc.transitioningDelegate = self.pushAnimator
        }
    }
}

extension CartController {
    
    func close() {
        self.transitioningDelegate = self.slideAnimator
        self.dismiss(animated: true, completion: nil)
    }
    
    func removeItem(indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath) as! CartTableCell
        
        Cart.instance.remove(item: cell.item!)
    }
    
    func incrementQuantity(item: CartItem) {
        Cart.instance.increment(item: item)
    }
    
    func decrementQuantity(item: CartItem) {
        Cart.instance.decrement(item: item)
    }
    
}
