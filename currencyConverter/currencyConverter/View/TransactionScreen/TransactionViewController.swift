//
//  TransactionViewController.swift
//  currencyConverter
//
//  Created by Nicks Villanueva on 10/8/22.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Alamofire
import CDAlertView

class TransactionViewController: BaseViewController {
    
    // MARK: Variable Declaration
    
    let viewModel = TransactionViewModel()
    
    let disposeBag = DisposeBag()
    
    // MARK: UI Declaration
    
    let scrollContainer: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let mainContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let balanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.text = "Account Dashboard"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let walletContainer: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.wallet_bg_color()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let walletBackground: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.gradient_bg()!
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.alpha = 1.0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let totalBalance: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "MY BALANCES"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    let walletStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let convertionContainer: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.convertion_container_bg_color()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.contentMode = .scaleToFill
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let sellTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Sell",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        textField.keyboardType = .numberPad
        textField.textColor = .white
        textField.font = UIFont.systemFont(ofSize: 25, weight: .regular)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let currenySellLabel: CurrencySelectorView = {
        let view = CurrencySelectorView()
        view.tag = 0
        view.currencyLabel.text = "EUR - Europian Currency"
        view.flagIcon.image = R.image.ic_euro()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let recivedTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Recieved",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        textField.keyboardType = .numberPad
        textField.textColor = R.color.wallet_bg_color()
        textField.font = UIFont.systemFont(ofSize: 25, weight: .regular)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    let lineSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    let currenyRecLabel: CurrencySelectorView = {
        let view = CurrencySelectorView()
        view.tag = 1
        view.currencyLabel.text = "USD - United States Currency"
        view.flagIcon.image = R.image.ic_usa()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let convertButton: UIButton = {
        let button = UIButton()
        button.setTitle("Convert", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.layer.cornerRadius = 10
        button.backgroundColor = R.color.button_color()
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = R.color.main_color()
        walletContainer.insertSubview(walletBackground, at: 0)
        
        configureUI()
        configureBindings()
        configureTappableUI()
        
        
        viewModel.setSellCurrencyCode(code: "EUR")
        viewModel.setRecievedCurrencyCode(code: "USD")
        viewModel.getWalletDetails()
        
        configureConvertionButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    // MARK: Private fuction for UI Configuration and Bindings
    
    private func configureUI() {
        
        self.view.addSubview(convertButton)
        convertButton.snp.makeConstraints { make in
            make.left.equalTo(view.snp.left).offset(40)
            make.right.equalTo(view.snp.right).offset(-40)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        
        self.view.addSubview(scrollContainer)
        scrollContainer.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.width.equalToSuperview()
            make.bottom.equalTo(convertButton.snp.top)
        }
        
        scrollContainer.addSubview(mainContainer)
        mainContainer.snp.makeConstraints { make in
            make.top.equalTo(scrollContainer.snp.top)
            make.width.equalTo(scrollContainer.snp.width)
            make.bottom.equalTo(scrollContainer.snp.bottom)
        }
        
        mainContainer.addSubview(balanceLabel)
        balanceLabel.snp.makeConstraints { make in
            make.top.equalTo(mainContainer.snp.top)
            make.left.equalTo(mainContainer.snp.left).offset(20)
            make.right.equalTo(mainContainer.snp.right).offset(-20)
        }
        
        mainContainer.addSubview(walletContainer)
        walletContainer.snp.makeConstraints { make in
            make.top.equalTo(balanceLabel.snp.bottom).offset(20)
            make.left.equalTo(mainContainer.snp.left).offset(20)
            make.right.equalTo(mainContainer.snp.right).offset(-20)
        }
        
        walletContainer.addSubview(walletBackground)
        walletBackground.snp.makeConstraints { make in
            make.left.right.equalTo(walletContainer)
            make.height.equalTo(300)
        }
        
        walletContainer.addSubview(totalBalance)
        totalBalance.snp.makeConstraints { make in
            make.top.equalTo(walletContainer.snp.top).offset(20)
            make.left.equalTo(walletContainer.snp.left).offset(20)
            make.right.equalTo(walletContainer.snp.right).offset(-20)
        }
        
        walletContainer.addSubview(walletStackView)
        walletStackView.snp.makeConstraints { make in
            make.top.equalTo(totalBalance.snp.bottom).offset(12)
            make.left.equalTo(walletContainer.snp.left).offset(20)
            make.right.equalTo(walletContainer.snp.right).offset(-20)
            make.bottom.equalTo(walletContainer.snp.bottom).offset(-20)
        }
        
//        walletContainer.addSubview(currentEURBalance)
//        currentEURBalance.snp.makeConstraints { make in
//            make.top.equalTo(walletStackView.snp.bottom).offset(12)
//            make.left.equalTo(walletContainer.snp.left).offset(20)
//            make.right.equalTo(walletContainer.snp.right).offset(-20)
//
//        }
//
//        walletContainer.addSubview(currentUSDBalance)
//        currentUSDBalance.snp.makeConstraints { make in
//            make.top.equalTo(currentEURBalance.snp.bottom).offset(8)
//            make.left.equalTo(walletContainer.snp.left).offset(20)
//            make.right.equalTo(walletContainer.snp.right).offset(-20)
//
//        }
//
//        walletContainer.addSubview(currentJPYBalance)
//        currentJPYBalance.snp.makeConstraints { make in
//            make.top.equalTo(currentUSDBalance.snp.bottom).offset(8)
//            make.left.equalTo(walletContainer.snp.left).offset(20)
//            make.right.equalTo(walletContainer.snp.right).offset(-20)
//            make.bottom.equalTo(walletContainer.snp.bottom).offset(-20)
//        }
        
        mainContainer.addSubview(convertionContainer)
        convertionContainer.snp.makeConstraints { make in
            make.top.equalTo(walletContainer.snp.bottom).offset(20)
            make.left.equalTo(mainContainer.snp.left).offset(20)
            make.right.equalTo(mainContainer.snp.right).offset(-20)
            make.bottom.equalTo(mainContainer.snp.bottom)
        }
        
        convertionContainer.addSubview(currenySellLabel)
        currenySellLabel.snp.makeConstraints { make in
            make.top.equalTo(convertionContainer.snp.top).offset(10)
            make.left.equalTo(convertionContainer.snp.left).offset(10)
            make.right.equalTo(convertionContainer.snp.right).offset(-10)
            make.height.equalTo(50)
        }
        
        convertionContainer.addSubview(sellTextField)
        sellTextField.snp.makeConstraints { make in
            make.top.equalTo(currenySellLabel.snp.bottom).offset(20)
            make.left.equalTo(convertionContainer.snp.left).offset(20)
            make.right.equalTo(convertionContainer.snp.right).offset(-20)
            
        }
        
        convertionContainer.addSubview(lineSeparator)
        lineSeparator.snp.makeConstraints { make in
            make.top.equalTo(sellTextField.snp.bottom).offset(15)
            make.left.equalTo(convertionContainer.snp.left).offset(10)
            make.right.equalTo(convertionContainer.snp.right).offset(-10)
            make.height.equalTo(1)
            
        }
        
        convertionContainer.addSubview(currenyRecLabel)
        currenyRecLabel.snp.makeConstraints { make in
            make.top.equalTo(lineSeparator.snp.bottom).offset(10)
            make.left.equalTo(convertionContainer.snp.left).offset(10)
            make.right.equalTo(convertionContainer.snp.right).offset(-10)
            make.height.equalTo(50)
        }
        
        convertionContainer.addSubview(recivedTextField)
        recivedTextField.snp.makeConstraints { make in
            make.top.equalTo(currenyRecLabel.snp.bottom).offset(20)
            make.left.equalTo(convertionContainer.snp.left).offset(20)
            make.right.equalTo(convertionContainer.snp.right).offset(-20)
            make.bottom.equalTo(convertionContainer.snp.bottom).offset(-20)
        }
        
    }
    
    private func configureBindings() {
        sellTextField.rx.controlEvent([.editingChanged, .editingDidEnd])
            .subscribe({ [weak self] _ in
                guard let strongSelf = self else { return }
                
                guard let amount = strongSelf.sellTextField.text else { return }
                
                if strongSelf.viewModel.isValidAmount(amount: Double(amount) ?? 0.0) {
                    strongSelf.viewModel.getCovertedCurrency(amount: strongSelf.sellTextField.text)
                }else {
                    strongSelf.showErrorInput()
                }
                
                strongSelf.configureConvertionButton()
                          
            }).disposed(by: disposeBag)
        
        viewModel.convertedAmountRelay
            .asDriver()
            .drive(onNext: { [weak self] amount in
                self?.recivedTextField.text = amount
            }).disposed(by: disposeBag)
        
        
        viewModel.walletRelay
            .asDriver()
            .drive(onNext: { [weak self] wallet in
                print(wallet)
                self?.walletStackView.removeAllArrangedSubviews()
                for (index, walletItem) in wallet.enumerated() {
                    let label = UILabel()
                    label.textColor = .white
                    label.font = UIFont.systemFont(ofSize: index == 0 ? 30: 20,
                                                   weight: .semibold)
                    
                    let amountFormat = String(format: "%.2f", Double(walletItem.amount))
                    label.text = "\(walletItem.currencySymbol) \(amountFormat)"
                    
                    self?.walletStackView.addArrangedSubview(label)
                }
                
                self?.view.setNeedsDisplay()
                self?.view.layoutIfNeeded()
                
            }).disposed(by: disposeBag)
        
        convertButton.rx.tap
            .bind(onNext: { [weak self] in
                
                guard let strongSelf = self else { return }
                
                guard let amount = strongSelf.sellTextField.text else { return }
                
                strongSelf.viewModel.proccessConvertion(sellAmount: Double(amount) ?? 0.0)
               
                strongSelf.displaySuccessMessage()
                
            }).disposed(by: disposeBag)
    }
  
    // MARK: Private Functions
 
    private func displaySuccessMessage() {
        
        if let sellAmount = self.sellTextField.text,
           let sellCode = self.viewModel.sellCurrencyCode.value,
           let recievedAmount = self.recivedTextField.text,
           let recivedCode = self.viewModel.recievedCurrencyCode.value {
            
            let commissionAmmount = String(format: "%.4f",
                                           self.viewModel.getCommissionAmmount(deductedAmount: Double(sellAmount) ?? 0.0))
            
            let commissionFee = BalanceManager.shared.getRemainingFreeTransaction() <= 0 ? "Commission fee - \(commissionAmmount) \(sellCode)" : ""
            
            let alert = CDAlertView(title: "Success",
                                    message: "You converted \(sellAmount) \(sellCode) to \(recievedAmount) \(recivedCode). \(commissionFee)",
                                    type: .success)
            let doneAction = CDAlertViewAction(title: "Done")
            alert.add(action: doneAction)
            alert.show()
            
        }
        
        
    }
    
    private func showErrorInput() {
        let alert = CDAlertView(title: "Invalid",
                                message: "Unable to convert. Insufficient balance",
                                type: .error)
        let doneAction = CDAlertViewAction(title: "Continue")
        alert.add(action: doneAction)
        alert.show()
        
        sellTextField.text = ""
        viewModel.getCovertedCurrency(amount: "")
    }
    
    private func configureTappableUI() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapSellCurrecy))
        currenySellLabel.isUserInteractionEnabled = true
        currenySellLabel.addGestureRecognizer(tap)
        
        let tapRecived = UITapGestureRecognizer(target: self, action: #selector(didTapRecievedCurrency))
        currenyRecLabel.isUserInteractionEnabled = true
        currenyRecLabel.addGestureRecognizer(tapRecived)
    }
    
    @objc private func didTapSellCurrecy() {
        chooseCurrency(viewTag: currenySellLabel.tag)
    }
    
    @objc private func didTapRecievedCurrency() {
        chooseCurrency(viewTag: currenyRecLabel.tag)
    }
    
    private func chooseCurrency(viewTag: Int) {
        let vc = CurrencyPickerScreenViewController()
        vc.delegate = self
        vc.viewTag = viewTag
        vc.modalPresentationStyle = .formSheet
        self.present(vc, animated: true, completion: nil)
    }
    
    private func configureCurrencyView(currency: Currency?, tag: Int){
        guard let currencyModel = currency else { return }
        
        if tag == 0 {
            setViewCurrency(view: currenySellLabel, currency: currencyModel)
            viewModel.setSellCurrencyCode(code: currencyModel.currencyCode)
        }else {
            setViewCurrency(view: currenyRecLabel, currency: currencyModel)
            viewModel.setRecievedCurrencyCode(code: currencyModel.currencyCode)
        }
    }
    
    private func configureConvertionButton() {
        self.convertButton.alpha = self.sellTextField.text == "" || self.recivedTextField.text == "" ? 0.5 : 1.0
        self.convertButton.isEnabled = self.sellTextField.text != ""
    }
    
    
    private func setViewCurrency(view: CurrencySelectorView, currency: Currency) {
        view.flagIcon.image = UIImage(named: currency.currencyIcon)
        view.currencyLabel.text = "\(currency.currencyCode) - \(currency.currencyDescription)"
        view.setNeedsDisplay()
        view.layoutIfNeeded()
    }
    
    @objc private func convert() {
        let vc = CurrencyPickerScreenViewController()
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {

        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = scrollContainer.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        scrollContainer.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification) {

        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollContainer.contentInset = contentInset
    }
  
}

extension TransactionViewController: CurrencyPickerDelegate {
    func selectedCurrency(currency: Currency?, tag: Int) {
        self.sellTextField.text = ""
        self.recivedTextField.text = ""
        self.configureCurrencyView(currency: currency, tag: tag)
    }
}

extension UIStackView {
    func removeAllArrangedSubviews() {
        arrangedSubviews.forEach {
            self.removeArrangedSubview($0)
            NSLayoutConstraint.deactivate($0.constraints)
            $0.removeFromSuperview()
        }
    }
}
