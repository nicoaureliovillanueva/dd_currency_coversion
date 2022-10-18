//
//  CurrencySelectorView.swift
//  currencyConverter
//
//  Created by Nicks Villanueva on 10/12/22.
//

import Foundation
import SnapKit
import UIKit

class CurrencySelectorView: UIView {
    
    
    let flagIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let currencyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "EUR - Europian Currency"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let arrowIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.tintColor = UIColor.white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
      }
      
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        self.addSubview(flagIcon)
        flagIcon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.width.height.equalTo(40)
        }
        
        self.addSubview(currencyLabel)
        currencyLabel.snp.makeConstraints { make in
            make.centerY.equalTo(flagIcon.snp.centerY)
            make.left.equalTo(flagIcon.snp.right).offset(10)
        }
        
        self.addSubview(arrowIcon)
        arrowIcon.snp.makeConstraints { make in
            make.centerY.equalTo(currencyLabel.snp.centerY)
            make.right.equalTo(self.snp.right).offset(-10)
            make.width.height.equalTo(20)
        }
        
    }
}
