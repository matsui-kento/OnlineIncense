//
//  DetailViewController.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/11.
//

import UIKit

class DetailViewController: UIViewController {

    private let deceasedNameLabel = CommonTitleLabel(label: "故人")
    private let homelessLabel = CommonTitleLabel(label: "喪家")
    private let placeLabel = CommonTitleLabel(label: "式場")
    private let addressLabel = CommonTitleLabel(label: "住所")
    private let scheduleLabel = CommonTitleLabel(label: "日程")
    private let deceasedDiscriptionLabel = DetailDiscriptionLabel(label: "松井建登")
    private let homelessDiscriptionLabel = DetailDiscriptionLabel(label: "松井家")
    private let placeDiscriptionLabel = DetailDiscriptionLabel(label: "忠岡斎場")
    private let addressDiscriptionLabel = DetailDiscriptionLabel(label: "大阪府泉北郡忠岡町忠岡南2-17-33")
    private let scheduleDiscriptionLabel = DetailDiscriptionLabel(label: "7/13 19時")
    private let rejectionDiscription = RejectionDiscription()
    private let writeButton = ActionButton(text: "芳名録を記入する")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
    }
    
    private func setupLayout() {

        let deceasedStackView = UIStackView(arrangedSubviews: [deceasedNameLabel, deceasedDiscriptionLabel])
        let homelessStackView = UIStackView(arrangedSubviews: [homelessLabel, homelessDiscriptionLabel])
        let placeStackView = UIStackView(arrangedSubviews: [placeLabel, placeDiscriptionLabel])
        let addressStackView = UIStackView(arrangedSubviews: [addressLabel, addressDiscriptionLabel])
        let scheduleStackView = UIStackView(arrangedSubviews: [scheduleLabel, scheduleDiscriptionLabel])
        let stackViews = [deceasedStackView, homelessStackView, placeStackView, addressStackView, scheduleStackView]
        stackViews.forEach {
            $0.axis = .vertical
            $0.spacing = 5
        }
        
        let baseStackView = UIStackView(arrangedSubviews: stackViews)
        baseStackView.axis = .vertical
        baseStackView.spacing = 20
        
        view.addSubview(baseStackView)
        view.addSubview(rejectionDiscription)
        view.addSubview(writeButton)
        baseStackView.anchor(top: view.topAnchor ,left: view.leftAnchor, right: view.rightAnchor, topPadding: 120, leftPadding: 25, rightPadding: 25)
        rejectionDiscription.anchor(top: baseStackView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, topPadding: 20, leftPadding: 25, rightPadding: 25)
        writeButton.anchor(top: rejectionDiscription.bottomAnchor, centerX: view.centerXAnchor, width: view.bounds.width - 50, height: 50 ,topPadding: 20)
    }

}
