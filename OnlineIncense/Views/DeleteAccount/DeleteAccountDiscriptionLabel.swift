//
//  DeleteAccountDiscriptionLabel.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/26.
//

import UIKit

class DeleteAccountDiscriptionLabel: UILabel {
    
    init() {
        super.init(frame: .zero)
        text = "アカウントを削除すると、作成した芳名録や香典のデータが全て消えてしまいます。アカウントを削除するときは、以下の2点を確認してください。\n\n・芳名録をもう閲覧することがない\n・香典の振込を確認できている\n\nこの2点を確認後、アカウントを削除してください。アカウントを削除すると、アカウントに紐づく芳名録、香典、口座情報含む個人情報は削除されます。そのため、削除されたアカウントに関する全てのことに対応できません。"
        font = .systemFont(ofSize: 20, weight: .semibold)
        numberOfLines = 0
        textColor = .darkGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


