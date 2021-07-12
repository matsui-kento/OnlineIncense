//
//  AuthTextButton.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/12.
//

import Foundation
import UIKit

class AuthTextButton: UIButton {
    
    override var isHighlighted: Bool {
        didSet {
            self.tintColor = isHighlighted ? .init(red: 255, green: 254, blue: 253, alpha: 0.1) : .init(red: 255, green: 254, blue: 253, alpha: 1)
        }
    }
    
    init(label: String) {
        super.init(frame: .zero)
        setTitle(label, for: .normal)
        tintColor = .init(red: 255, green: 254, blue: 253, alpha: 1)
        titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
