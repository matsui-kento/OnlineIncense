//
//  DetailTextView.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/19.
//

import UIKit

class DetailTextView: UITextView {
    
    init() {
        super.init(frame: CGRect.zero, textContainer: nil)
        font = .systemFont(ofSize: 18, weight: .bold)
        textColor = .black
        isEditable = false
        isSelectable = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

