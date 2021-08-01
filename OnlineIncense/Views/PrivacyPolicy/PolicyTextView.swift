//
//  PolicyTextView.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/08/01.
//

import Foundation
import UIKit

class PolicyTextView: UITextView {
    
    init(textString: String) {
        super.init(frame: CGRect.zero, textContainer: nil)
        text = textString
        font = .systemFont(ofSize: 18, weight: .bold)
        textColor = .darkGray
        isEditable = false
        isSelectable = false
        frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
