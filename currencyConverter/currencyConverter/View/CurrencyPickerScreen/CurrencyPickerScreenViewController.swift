//
//  CurrencyPickerScreenViewController.swift
//  currencyConverter
//
//  Created by Nicks Villanueva on 10/11/22.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol CurrencyPickerDelegate: AnyObject {
    func selectedCurrency(currency: Currency?, tag: Int)
}


class CurrencyPickerScreenViewController: UIViewController {
    
    let viewModel = CurrencyPickerScreenViewModel()
    
    let disposeBag = DisposeBag()
    
    weak var delegate: CurrencyPickerDelegate?
    
    var viewTag: Int?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Please select currency"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let currencyTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = R.color.main_color()
        return tableView
    }()
    
    override func viewDidLoad() {
        
        viewModel.getCurrencyData()
        
        self.view.backgroundColor = R.color.main_color()
        
        configureUI()
        configureBindings()
        configureTableView()
    }
    
    // MARK: Private functions
    
    private func configureTableView() {
        currencyTableView.register(CurrencyCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private func configureUI() {
        
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalTo(view.snp.left).offset(20)
            make.right.equalTo(view.snp.right).offset(-20)
        }
        
        self.view.addSubview(currencyTableView)
        currencyTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func configureBindings() {
        viewModel.currencyRelay
            .bind(to: currencyTableView.rx.items(cellIdentifier: "Cell", cellType: CurrencyCell.self)) { (row, data, cell) in
                cell.selectionStyle = .none
                
                if let currenyData = data {
                    cell.configureCell(model: currenyData)
                }
                
            }
            .disposed(by: disposeBag)
        
        currencyTableView.rx
            .modelSelected(Currency.self)
            .subscribe(onNext: { [weak self] currency in
                self?.dismiss(animated: true, completion: nil)
                self?.delegate?.selectedCurrency(currency: currency,
                                                 tag: self?.viewTag ?? 0)
            }).disposed(by: disposeBag)
        
        
    }
    
}
