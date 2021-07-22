//
//  DiscriptionLabel.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/11.
//

import UIKit

class CreateDiscriptionLabel: UILabel {
    
    init() {
        super.init(frame: .zero)
        text = "香典を受け取らない場合でも、オンライン芳名録としてご利用できます。マイページから香典を頂いた人や参列者などを確認できます。また、頂いた香典は「マイページ」>「作成した香典・芳名録を見る」>振込依頼をしたい香典を選ぶ >「香典の振込依頼」から振込申請ができます。\n＊香典を受け取る場合は10%の手数料がかかります。\n(例)100,000円の香典を頂いた場合、10%の10,000円が引かれた90,000円が銀行口座に振り込まれます。"
        font = .systemFont(ofSize: 20, weight: .semibold)
        numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

