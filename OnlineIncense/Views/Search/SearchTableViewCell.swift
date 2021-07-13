//
//  SearchTableViewCell.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/11.
//

import Foundation
import UIKit

class SearchTableViewCell: UITableViewCell {
    
    let nameLabel: UILabel = {
        var label = UILabel()
        label.text = ""
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    let placeLabel: UILabel = {
        var label = UILabel()
        label.text = ""
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let baseStackView = UIStackView(arrangedSubviews: [nameLabel, placeLabel])
        baseStackView.axis = .horizontal
        contentView.addSubview(baseStackView)
        baseStackView.anchor(left: contentView.leftAnchor, right: contentView.rightAnchor, centerY: centerYAnchor)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
