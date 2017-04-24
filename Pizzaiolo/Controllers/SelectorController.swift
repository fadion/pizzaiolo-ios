//
//  SelectorController.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 07/03/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

class SelectorController: ViewControllerWithNavBar {
    
    @IBOutlet weak var pizza: UICollectionView!
    @IBOutlet weak var pizzaMenu: UICollectionView!
    @IBOutlet weak var categoryMenu: UICollectionView!
    @IBOutlet weak var scrollProgress: UIProgressView!
    
    var selectedPizza: Int?
    
    fileprivate let disposeBag = DisposeBag()
    fileprivate lazy var pizzaViewModel = Variable<[PizzaViewModel]>([])
    fileprivate lazy var categoryViewModel = Variable<[CategoryViewModel]>([])
    fileprivate var pizzaAllViewModel: [PizzaViewModel]?
    fileprivate var nextCell: PizzaCollectionCell?
    fileprivate var filterIds: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fillWithData()
        self.setupPizzas()
        self.setupPizzaMenu()
        self.setupCategoryMenu()
        self.moveToPizza()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Center horizontally the first and last pizzas in the menu.
        let inset = (self.view.frame.size.width - (self.pizzaMenu.collectionViewLayout as! UICollectionViewFlowLayout).itemSize.width) * 0.5 - 25
        self.pizzaMenu.contentInset.left = inset
        self.pizzaMenu.contentInset.right = inset
        
        self.pizzaMenu.decelerationRate = UIScrollViewDecelerationRateFast
    }
    
    override func viewWillLayoutSubviews() {
        // Fixes the problem of the collectionview layout
        // not calculating the correct cell size when
        // changing orientation.
        self.pizza.collectionViewLayout.invalidateLayout()
    }
    
    private func fillWithData() {
        CategoryManager().all()
            .flatMap { [weak self] categories -> Observable<[PizzaViewModel]> in
                self?.categoryViewModel.value = categories
                
                return PizzaManager().all()
            }
            .subscribe(onNext: { [weak self] pizza in
                self?.pizzaViewModel.value = pizza
            }, onError: { [weak self] _ in
                if self?.pizzaViewModel.value.count == 0 {
                    self?.pizza.backgroundView = NetworkErrorView(withAction: {
                        self?.fillWithData()
                    })
                }
            }).disposed(by: self.disposeBag)
    }

    private func setupPizzas() {
        self.pizza.rx.setDelegate(self).disposed(by: self.disposeBag)

        self.pizzaViewModel.asObservable()
            .subscribe(onNext: { [weak self] pizza in
                self?.pizza.backgroundView = pizza.count > 0 ? nil : PizzaLoadingView()
            }).disposed(by: self.disposeBag)
        
        self.pizzaViewModel.asObservable()
            .bindTo(self.pizza.rx.items(
                cellIdentifier: "pizza",
                cellType: PizzaCollectionCell.self)) { [weak self] (_, viewModel, cell) in
                    cell.viewModel = viewModel
                    
                    // The tap event is disposed on the cell reusable bag,
                    // otherwise it will be messed up by cell reuse.
                    cell.addToCart.button.rx.tap.subscribe(onNext: { [weak self] in
                        self?.addToCart(cell: cell)
                    }).disposed(by: cell.disposeBag)
            }.disposed(by: self.disposeBag)
    }
    
    private func setupPizzaMenu() {
        self.pizzaMenu.rx.setDelegate(self).disposed(by: self.disposeBag)
        
        self.pizzaViewModel.asObservable()
            .bindTo(self.pizzaMenu.rx.items(
                cellIdentifier: "pizzamenu",
                cellType: PizzaMenuCollectionCell.self)) { (_, viewModel, cell) in
                    cell.viewModel = viewModel
            }.disposed(by: self.disposeBag)
    }
    
    private func setupCategoryMenu() {
        self.categoryMenu.allowsMultipleSelection = true
        self.categoryMenu.rx.setDelegate(self).disposed(by: self.disposeBag)
        
        self.categoryViewModel.asObservable()
            .bindTo(self.categoryMenu.rx.items(
                cellIdentifier: "categoryMenu",
                cellType: CategoryCollectionCell.self)) { (_, viewModel, cell) in
                    cell.viewModel = viewModel
            }.disposed(by: self.disposeBag)
    }
    
    private func moveToPizza() {
        // Check if a pizza was selected from the previous
        // view controller, so it can move to it.
        if let selected = self.selectedPizza, selected < self.pizzaViewModel.value.count - 1 {
            // Reload data and layout cells, so the call to scrollToItem()
            // doesn't try to scroll on an inexistent cell.
            self.pizza.reloadData()
            self.pizza.layoutIfNeeded()
            
            self.pizza.scrollToItem(at: IndexPath(item: selected, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
}

extension SelectorController {
    
    func addToCart(cell: PizzaCollectionCell) {
        guard let vm = cell.viewModel else { return }
        
        cell.animateAddToCartButton()
        
        let item = CartItem(
            id: vm.id,
            name: vm.name.value,
            summary: vm.summary.value,
            price: vm.price.value,
            photo: cell.photo.image!)
        
        Cart.instance.add(item: item)
    }
    
    func filterByCategory() {
        // Keep a copy of the unfiltered pizzas so it
        // can be restored when filters are removed.
        if self.pizzaAllViewModel == nil {
            self.pizzaAllViewModel = self.pizzaViewModel.value
        }
        
        PizzaManager().whereCategory(ids: self.filterIds)
            .map { [unowned self] viewModels in
                // An empty filter array means that all the
                // filters are removed, so the complete list
                // of pizzas is restored.
                return self.filterIds.isEmpty ? self.pizzaAllViewModel! : viewModels
            }
            .subscribe(onNext: { [weak self] viewModels in
                self?.pizzaViewModel.value = viewModels
            }).disposed(by: self.disposeBag)
    }
    
}

extension SelectorController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView {
        case self.pizza:
            return self.pizza.bounds.size
        case self.pizzaMenu:
            return CGSize(width: 80, height: 80)
        case self.categoryMenu:
            // As the category menu is composed of labels,
            // it's width can be made dynamic by calculating
            // the size of a string.
            let name = self.categoryViewModel.value[indexPath.row].name.value as NSString
            let size = name.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: Theme.Font.body)])
            
            return CGSize(width: size.width + 20, height: size.height + 10)
        default:
            return .zero
        }
    }
    
}

extension SelectorController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.self == self.pizza.self {
            // Calculate the relative position by substracting a
            // screen size, so the progress view goes from 0 (first item) to
            // the screen width (last item).
            self.scrollProgress.progress = Float(scrollView.contentOffset.x / (scrollView.contentSize.width - self.view.frame.width))
            
            self.pizzaMenu.contentOffset.x = scrollView.contentOffset.x / scrollView.contentSize.width * self.pizzaMenu.contentSize.width - self.pizzaMenu.contentInset.left
            
            // If "willDisplay" got a cell, animate it.
            if let cell = self.nextCell, let index = self.pizza.indexPath(for: cell) {
                let position = self.pizza.frame.width * CGFloat(index.row) - scrollView.contentOffset.x
                cell.animateParallax(position: position)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.pizzaMenu {
            // Both collectionviews have the same exact number of
            // items, so both are scrolled to the same position.
            self.pizzaMenu.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.pizza.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        else if collectionView == self.categoryMenu {
            self.filterIds.append(self.categoryViewModel.value[indexPath.row].id)
            self.filterByCategory()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == self.categoryMenu {
            self.filterIds.remove(at: self.filterIds.index(of: self.categoryViewModel.value[indexPath.row].id)!)
            self.filterByCategory()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == self.pizza {
            // Save the cell that's going to be displayed, so it
            // can be animated once scrolled.
            if let cell = cell as? PizzaCollectionCell {
                self.nextCell = cell
            }
        }
    }
    
}
