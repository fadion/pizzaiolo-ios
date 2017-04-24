//
//  HomeController.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 18/02/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class HomeController: ViewControllerWithNavBar {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    private lazy var viewModel = Variable<[FeaturedViewModel]>([])
    
    private let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.activityIndicatorViewStyle = .gray
        ai.startAnimating()
        
        return ai
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fillWithData()
        self.setupTable()
    }
    
    private func fillWithData() {
        self.tableView.backgroundView = nil
        
        FeaturedManager().all()
            .subscribe(onNext: { [weak self] viewModels in
                self?.viewModel.value = viewModels
            }, onError: { [weak self] _ in
                if self?.viewModel.value.count == 0 {
                    self?.tableView.backgroundView = NetworkErrorView(withAction: {
                        self?.fillWithData()
                    })
                }
            }).disposed(by: self.disposeBag)
    }
    
    private func setupTable() {
        // Show the loading view as the backgroundView property
        // depending on whether there are data or not.
        self.viewModel.asObservable()
            .subscribe(onNext: { [weak self] viewModels in
                self?.tableView.backgroundView = viewModels.count > 0 ? nil : self?.activityIndicator
            }).disposed(by: self.disposeBag)
        
        self.viewModel.asObservable()
            .bindTo(self.tableView.rx.items(
                cellIdentifier: "featured",
                cellType: FeaturedTableCell.self)) { (_, viewModel, cell) in
                    cell.viewModel = viewModel
            }.disposed(by: self.disposeBag)
    }
    
}

extension HomeController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.performSegue(withIdentifier: "pizzaSelectionWithPizza", sender: self)
        case 1:
            self.performSegue(withIdentifier: "pizzaSelection", sender: self)
        case 2:
            self.performSegue(withIdentifier: "pizzaMaker", sender: self)
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? FeaturedTableCell {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                cell.photo.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                cell.overlay.alpha = 0
            }, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? FeaturedTableCell {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                cell.photo.transform = CGAffineTransform.identity
                cell.overlay.alpha = 1
            }, completion: nil)
        }
    }
    
}

extension HomeController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pizzaSelectionWithPizza" {
            if let destination = segue.destination as? SelectorController {
                // Pass an item number for the destination collection view
                // indexpath. Normally this should be an ID from the data source.
                destination.selectedPizza = 2
            }
        }
    }
    
}
