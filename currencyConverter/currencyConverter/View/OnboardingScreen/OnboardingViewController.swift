//
//  OnboardingViewController.swift
//  currencyConverter
//
//  Created by Nicks Villanueva on 10/8/22.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class OnboardingViewController: UIViewController {
    
    // MARK: Variable Declaration
    
    // let viewModel = OnBoardingViewModel()
    
    let disposeBag = DisposeBag()
    
    // MARK: UI Declaration
    
    
    private lazy var appTitle: UILabel = {
        let label = UILabel()
        label.text = "Onboarding Screen"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(self.redirectToTransactionScreen), for: .touchUpInside)
        return button
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureBindings()
    }
    
    // MARK: Private fuction for UI Configuration and Bindings
    
    private func configureUI() {
        self.view.addSubview(appTitle)
        appTitle.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        self.view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(appTitle.snp.bottom).offset(20)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
        
    }
    
    private func configureBindings() {
        
    }
  
    // MARK: Private Functions
    
    @objc private func redirectToTransactionScreen() {
        let vc = TransactionViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
  
}
