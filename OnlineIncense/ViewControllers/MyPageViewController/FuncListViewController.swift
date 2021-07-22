//
//  FuncListViewController.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/18.
//

import UIKit
import PKHUD
import RxSwift
import RxCocoa
import Firebase

protocol deleteInfoProtocol {
    func  deleteInfo(success: Bool)
}

class FuncListViewController: UIViewController {
    
    var delegate: deleteInfoProtocol?
    private let disposeBag = DisposeBag()
    private let infoDetailButton = ActionButton(text: "香典・芳名録の詳細")
    private let participantListButton = ActionButton(text: "参列者の一覧")
    private let moneyButton = ActionButton(text: "香典の振込依頼")
    private let deleteButton = ImportantButton(text: "芳名録の削除")
    var info: Info?
    var documentID = ""
    var incense = false
    var transfer = false
    
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
        
        if transfer {
            moneyButton.isHidden = true
        } else {
            moneyButton.isHidden = false
        }
        
        view.backgroundColor = .white
        deleteButton.backgroundColor = .red
        let baseStackView = UIStackView(arrangedSubviews: [infoDetailButton, participantListButton, moneyButton, deleteButton])
        baseStackView.spacing = 10
        baseStackView.distribution = .fillEqually
        baseStackView.axis = .vertical
        view.addSubview(baseStackView)
        deleteButton.anchor(height: 50)
        baseStackView.anchor(left: view.leftAnchor, right: view.rightAnchor, centerY: view.centerYAnchor, leftPadding: 25, rightPadding: 25)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupBindings() {
        
        infoDetailButton.rx.tap
            .asDriver()
            .drive() { _ in
                self.toDetailInfo()
            }
            .disposed(by: disposeBag)
        
        participantListButton.rx.tap
            .asDriver()
            .drive() { _ in
                self.toparticipantList()
            }
            .disposed(by: disposeBag)
        
        moneyButton.rx.tap
            .asDriver()
            .drive() { _ in
                self.toBankAccounts()
            }
            .disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .asDriver()
            .drive() { _ in
                self.deleteInfo()
            }
            .disposed(by: disposeBag)
        
    }
    
    private func toDetailInfo() {
        
        let detailVC = DetailViewController()
        detailVC.deceasedDiscriptionLabel.text = info?.deceasedName
        detailVC.homelessDiscriptionLabel.text = info?.homeless
        detailVC.placeDiscriptionLabel.text = info?.place
        detailVC.addressDiscriptionLabel.text = info?.address
        detailVC.scheduleDiscriptionLabel.text = info?.schedule
        detailVC.documentID = documentID
        detailVC.incense = incense
        detailVC.otherTextView.text = info?.other
        detailVC.info = info
        detailVC.writeButton.isHidden = true
        detailVC.rejectionDiscription.isHidden = true
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    private func toparticipantList() {
        let participantListVC = ParticipantListViewController()
        participantListVC.documentID = documentID
        self.navigationController?.pushViewController(participantListVC, animated: true)
    }
    
    private func toBankAccounts() {
        let bankAccountVC = BankAccountViewController()
        bankAccountVC.info = info
        self.navigationController?.pushViewController(bankAccountVC, animated: true)
        
    }
    
    private func deleteInfo() {
        let alert = UIAlertController(title: "芳名録を削除する", message: "削除すると、復元できません。", preferredStyle: .actionSheet)
        let delete = UIAlertAction(title: "削除する", style: .destructive, handler: {
            (action: UIAlertAction!) in
            Firestore.deleteInfo(infoID: self.documentID) { success in
                if success {
                    self.delegate?.deleteInfo(success: true)
                    self.navigationController?.popViewControllers(viewsToPop: 1)
                } else {
                    HUD.flash(.labeledError(title: "エラーが発生しました。", subtitle: "App Storeから開発者に連絡してください。"), delay: 5)
                }
            }
        })
        alert.addAction(delete)
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
