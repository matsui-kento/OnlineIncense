//
//  CreateViewController.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/10.
//

import UIKit
import RxCocoa
import RxSwift

class CreateViewController: UIViewController {

    private let disposeBag = DisposeBag()
    private let createTitleLabel = CreateTitleLabel()
    private let createDiscriptionLabel = CreateDiscriptionLabel()
    private let createButtonWithIncense = ActionButton(text: "香典・芳名録を作成する")
    private let createButton = ActionButton(text: "芳名録のみを作成する")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.parent?.navigationItem.title = "香典・芳名録を作成する"
    }
    

    private func setupLayout() {
        
        let baseStackView = UIStackView(arrangedSubviews: [createTitleLabel, createDiscriptionLabel, createButtonWithIncense, createButton])
        baseStackView.axis = .vertical
        baseStackView.spacing = 10
        view.addSubview(baseStackView)
        baseStackView.anchor(left: view.leftAnchor, right: view.rightAnchor, centerY: view.centerYAnchor, leftPadding: 25, rightPadding: 25)
        createButtonWithIncense.anchor(height: 50)
        createButton.anchor(height: 50)
    }
    
    private func setupBindings() {
        
        createButtonWithIncense.rx.tap
            .asDriver()
            .drive() { _ in
                let createFormVC = CreateFormWithIncenseViewController()
                self.navigationController?.pushViewController(createFormVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        createButton.rx.tap
            .asDriver()
            .drive() { _ in
                let createFormVC = CreateFormViewController()
                self.navigationController?.pushViewController(createFormVC, animated: true)
            }
            .disposed(by: disposeBag)
        
    }

}
