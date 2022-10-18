//
//  CurrencyCell.swift
//  currencyConverter
//
//  Created by Nicks Villanueva on 10/11/22.
//

import Foundation
import UIKit
import SnapKit


class CurrencyCell: UITableViewCell {
    
    
    
    let currencyIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let currencyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    let currencyDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    class CustomTableViewCell: UITableViewCell {
        override var frame: CGRect {
            get {
                return super.frame
            }
            set (newFrame) {
                var frame = newFrame
                frame.origin.x += 20
                super.frame = frame
            }
        }
    }
    
    private func configureUI() {
        
        contentView.backgroundColor = R.color.main_color()
        
        
        contentView.addSubview(currencyIcon)
        currencyIcon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(20)
            make.width.height.equalTo(40)
        }
        
        contentView.addSubview(currencyLabel)
        currencyLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(currencyIcon.snp.right).offset(20)
            make.right.equalTo(contentView.snp.right)
            make.height.equalTo(30)
        }
        
        contentView.addSubview(currencyDescriptionLabel)
        currencyDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(currencyLabel.snp.bottom).offset(2)
            make.left.equalTo(currencyIcon.snp.right).offset(20)
            make.right.equalTo(contentView.snp.right)
            make.bottom.equalToSuperview()
        }
    }
    
    func configureCell(model: Currency?) {
        currencyLabel.text = model?.currencyCode
        currencyIcon.image = UIImage(named: model?.currencyIcon ?? "")
        currencyDescriptionLabel.text = model?.currencyDescription
    }
    
}
