//
//  CreateTextView.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/19.
//

import UIKit

class CreateTextView: UITextView {
    
    init() {
        super.init(frame: CGRect.zero, textContainer: nil)
        font = .systemFont(ofSize: 18, weight: .bold)
        textColor = .black
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = 10
        keyboardType = .default
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
