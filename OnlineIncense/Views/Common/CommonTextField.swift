//
//  NameTextField.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/10.
//

import Foundation
import UIKit

class CommonTextField : UITextField {
    
    init(text: String) {
        super.init(frame: .zero)
        
        placeholder = text
        font = .systemFont(ofSize: 18, weight: .bold)
        textColor = .black
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = 10
        keyboardType = .default
    }
    
    //入力したテキストの余白
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10.0, dy: 0.0)
    }
    
    //編集中のテキストの余白
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10.0, dy: 0.0)
    }
    
    //プレースホルダーの余白
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10.0, dy: 0.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
