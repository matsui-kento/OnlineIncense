//
//  ParticipantDetailViewController.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/14.
//

import UIKit

class ParticipantDetailViewController: UIViewController {
    private let padding = Padding.shared
    private let nameLabel = CommonTitleLabel(label: "名前")
    private let addressLabel = CommonTitleLabel(label: "住所")
    private let numberLabel = CommonTitleLabel(label: "電話番号")
    private let companyLabel = CommonTitleLabel(label: "会社/団体名")
    private let relationLabel = CommonTitleLabel(label: "ご関係")
    private let incenseLabel = CommonTitleLabel(label: "香典")
    let nameDiscriptionLabel = DetailDiscriptionLabel(label: "")
    let addressDiscriptionLabel = DetailDiscriptionLabel(label: "")
    let numberDiscriptionLabel = DetailDiscriptionLabel(label: "")
    let companyDiscriptionLabel = DetailDiscriptionLabel(label: "")
    let relationDiscriptionLabel = DetailDiscriptionLabel(label: "")
    let incenseDiscriptionLabel = DetailDiscriptionLabel(label: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "参列者の詳細"
        setupLayout()
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        
        if companyDiscriptionLabel.text == "" {
            companyDiscriptionLabel.text = "記載なし"
        }
        
        let nameStackView = UIStackView(arrangedSubviews: [nameLabel, nameDiscriptionLabel])
        let addressStackView = UIStackView(arrangedSubviews: [addressLabel, addressDiscriptionLabel])
        let numberStackView = UIStackView(arrangedSubviews: [numberLabel, numberDiscriptionLabel])
        let companyStackView = UIStackView(arrangedSubviews: [companyLabel, companyDiscriptionLabel])
        let relationStackView = UIStackView(arrangedSubviews: [relationLabel, relationDiscriptionLabel])
        let incenseStackView = UIStackView(arrangedSubviews: [incenseLabel, incenseDiscriptionLabel])
        let stackViews = [nameStackView, addressStackView, numberStackView, companyStackView, relationStackView, incenseStackView]
        stackViews.forEach {
            $0.axis = .vertical
            $0.spacing = 5
        }
        
        let baseStackView = UIStackView(arrangedSubviews: stackViews)
        baseStackView.axis = .vertical
        baseStackView.spacing = 20
        
        view.addSubview(baseStackView)
        baseStackView.anchor(top: view.topAnchor ,left: view.leftAnchor, right: view.rightAnchor, topPadding: padding.top, leftPadding: padding.left, rightPadding: padding.right)
        
        
    }
    
}
