//
//  ActionButton.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/10.
//

import Foundation
import UIKit

class ActionButton: UIButton {
    
    override var isHighlighted: Bool {
        didSet {
            self.backgroundColor = isHighlighted ? .init(red: 0, green: 0, blue: 0, alpha: 0.5) : .init(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    init(text: String) {
        super.init(frame: .zero)
        setTitle(text, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        layer.cornerRadius = 10
        backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
