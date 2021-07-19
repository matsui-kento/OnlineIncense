//
//  FuncListViewController.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/18.
//

import UIKit
import RxSwift
import RxCocoa

class FuncListViewController: UIViewController {

    private let disposeBag = DisposeBag()
    private let participantListButton = ActionButton(text: "参列者の一覧")
    private let moneyButton = ActionButton(text: "香典の振込依頼")
    private let deleteButton = ActionButton(text: "芳名録の削除")
    var documentID = ""
    var incense = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupBindings()
    }
    
    private func setupLayout() {
        
        if incense {
            moneyButton.isHidden = false
        } else {
            moneyButton.isHidden = true
        }
        
        view.backgroundColor = .white
        deleteButton.backgroundColor = .red
        let baseStackView = UIStackView(arrangedSubviews: [participantListButton, moneyButton, deleteButton])
        baseStackView.spacing = 10
        baseStackView.distribution = .fillEqually
        baseStackView.axis = .vertical
        view.addSubview(baseStackView)
        deleteButton.anchor(height: 50)
        baseStackView.anchor(left: view.leftAnchor, right: view.rightAnchor, centerY: view.centerYAnchor, leftPadding: 25, rightPadding: 25)
    }
    
    private func setupBindings() {
        
        participantListButton.rx.tap
            .asDriver()
            .drive() { _ in
                self.toparticipantList()
            }
            .disposed(by: disposeBag)
        
        moneyButton.rx.tap
            .asDriver()
            .drive() { _ in
                
            }
            .disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .asDriver()
            .drive() { _ in
                
            }
            .disposed(by: disposeBag)
        
    }
    
    private func toparticipantList() {
        let participantListVC = ParticipantListViewController()
        participantListVC.documentID = documentID
        self.navigationController?.pushViewController(participantListVC, animated: true)
    }
    
    private func toBankAccounts() {
        
        
    }
    
    private func deleteInfo() {
        
    }
    
    

}
