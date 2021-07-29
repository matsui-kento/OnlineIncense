//
//  DeleteAccountViewController.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/26.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase
import PKHUD

class DeleteAccountViewController: UIViewController {

    var infoArray = [Info]()
    var infoIDs: [String] = []
    var bankAccountArray = [BankAccount]()
    var bankAccountIDs: [String] = []
    private let disposeBag = DisposeBag()
    private let deleteTitleLabel = DeleteAccountTitleLabel()
    private let deleteDiscriptionLabel = DeleteAccountDiscriptionLabel()
    private let deleteButton = ImportantButton(text: "アカウントを削除")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupBindings()
    }
    
    private func setupLayout() {
        self.view.backgroundColor = .white
        self.navigationItem.title = "アカウントの削除"
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        fetchInfoFromMe(uid)
        fetchBankAcountArray(uid)
        
        let baseStackView = UIStackView(arrangedSubviews: [deleteTitleLabel, deleteDiscriptionLabel, deleteButton])
        baseStackView.axis = .vertical
        baseStackView.spacing = 10
        view.addSubview(baseStackView)
        baseStackView.anchor(left: view.leftAnchor, right: view.rightAnchor, centerY: view.centerYAnchor, leftPadding: 25, rightPadding: 25)
        deleteButton.anchor(height: 50)
    }
    
    private func setupBindings() {
        
        deleteButton.rx.tap
            .asDriver()
            .drive() { _ in
                self.deleteAccount()
            }
            .disposed(by: disposeBag)
        
    }
    
    private func deleteAccount() {
        let alert = UIAlertController(title: "アカウントを削除する", message: "上記の文章をしっかり読みましたか？", preferredStyle: .actionSheet)
        let deleteAccount = UIAlertAction(title: "削除する", style: .destructive, handler: {
            (action: UIAlertAction!) in
            
            self.deleteAllAccountData() { success in
                if success {
                    print("ユーザーに関する全てのデータを削除に成功")
                }
            }
            
        })
        alert.addAction(deleteAccount)
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    private func deleteAllAccountData(completion: @escaping (Bool) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.deleteAllParticipant(infoIDs: infoIDs) {
            Firestore.deleteAllInfo(infoIDs: self.infoIDs) {
                Firestore.deleteAllBankAccount(uid: uid, bankAccountIDs: self.bankAccountIDs) {
                    Firestore.deleteUserFromFirestore(uid: uid) {
                        self.deleteUserFromAuth {
                            self.navigationController?.popViewController(animated: true)
                            completion(true)
                        }
                    }
                }
            }
        }
    }
    
    
    private func deleteUserFromAuth(completion: @escaping () -> ()) {
        
        let user = Auth.auth().currentUser
        
        user?.delete { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                completion()
            }
        }
    }
    
    private func fetchInfoFromMe(_ uid: String) {
        Firestore.fetchInfoForMyPage(uid: uid) { infoArray in
            if infoArray != nil {
                self.infoArray = infoArray ?? [Info]()
                self.infoArray.forEach { self.infoIDs.append($0.documentID) }
            } else {
                HUD.flash(.labeledError(title: "エラーが発生しました。", subtitle: "もう一度やり直してください。\nもし何度やり直してもできない場合は開発者に連絡してください。"))
            }
        }
    }
    
    private func fetchBankAcountArray(_ uid: String) {
        Firestore.fetchBankAccount(uid: uid) { bankAccountArray in
            if bankAccountArray != nil {
                self.bankAccountArray = bankAccountArray ?? [BankAccount]()
                self.bankAccountArray.forEach { self.bankAccountIDs.append($0.documentID) }
            } else if bankAccountArray == nil {
                HUD.flash(.labeledError(title: "エラーが発生しました。", subtitle: "もう一度やり直してください。\nもし何度やり直してもできない場合は開発者に連絡してください。"))
            }
        }
    }
}
