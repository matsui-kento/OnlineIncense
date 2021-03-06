//
//  DetailViewController.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/11.
//

import UIKit
import RxCocoa
import RxSwift

class DetailViewController: UIViewController {

    private let deceasedNameLabel = CommonTitleLabel(label: "故人")
    private let homelessLabel = CommonTitleLabel(label: "喪家")
    private let placeLabel = CommonTitleLabel(label: "式場")
    private let addressLabel = CommonTitleLabel(label: "住所")
    private let scheduleLabel = CommonTitleLabel(label: "日程")
    let deceasedDiscriptionLabel = DetailDiscriptionLabel(label: "")
    let homelessDiscriptionLabel = DetailDiscriptionLabel(label: "")
    let placeDiscriptionLabel = DetailDiscriptionLabel(label: "")
    let addressDiscriptionLabel = DetailDiscriptionLabel(label: "")
    let scheduleDiscriptionLabel = DetailDiscriptionLabel(label: "")
    let otherTextView = DetailTextView()
    var documentID = ""
    var info: Info?
    var incense = false
    let rejectionDiscription = RejectionDiscription()
    let writeButton = ActionButton(text: "芳名録を記入する")
    private let disposeBag = DisposeBag()
    private let padding = Padding.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "香典・芳名録の詳細"
    }
    
    private func setupLayout() {
        
        if incense {
            rejectionDiscription.text = "芳名録を記入後、香典の手続きがございます。"
        }
        
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
        view.addSubview(otherTextView)
        view.addSubview(writeButton)
        baseStackView.anchor(top: view.topAnchor ,left: view.leftAnchor, right: view.rightAnchor, topPadding: padding.top, leftPadding: padding.left, rightPadding: padding.right)
        otherTextView.anchor(top: baseStackView.bottomAnchor, centerX: view.centerXAnchor, width: view.bounds.width - 50, height: 50 ,topPadding: 20)
        rejectionDiscription.anchor(top: otherTextView.bottomAnchor, centerX: view.centerXAnchor, width: view.bounds.width - 50, height: 50 ,topPadding: 20)
        writeButton.anchor(top: otherTextView.bottomAnchor, centerX: view.centerXAnchor, width: view.bounds.width - 50, height: 50 ,topPadding: 20)
        
        if otherTextView.text == "" {
            otherTextView.isHidden = true
        } else {
            otherTextView.isHidden = false
        }
    }
    
    private func setupBindings() {
        
        writeButton.rx.tap
            .asDriver()
            .drive() { _ in
                let writingVC = WritingFormViewController()
                writingVC.documentID = self.documentID
                writingVC.insence = self.incense
                writingVC.info = self.info
                self.navigationController?.pushViewController(writingVC, animated: true)
            }
            .disposed(by: disposeBag)
        
    }
}
