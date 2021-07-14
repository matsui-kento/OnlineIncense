//
//  MyPageViewController.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/10.
//

import UIKit
import RxCocoa
import RxSwift
import Firebase

class MyPageViewController: UIViewController {

    private let disposeBag = DisposeBag()
    private let nameLabel = CommonTitleLabel(label: "名前")
    private let logoutButton = ActionButton(text: "ログアウト")
    private let loginButton = ActionButton(text: "ログイン")
    private let lookButton = ActionButton(text: "作成した香典・芳名録を見る")
    private let privacyButton = ActionButton(text: "プライバシーポリシー")
    var user:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.parent?.navigationItem.title = "マイページ"
    }
    
    private func setupLayout() {
        
        if let uid = Auth.auth().currentUser?.uid {
            Firestore.fetchUser(uid: uid) { user in
                self.user = user
                self.nameLabel.text = user?.name
                self.loginButton.isHidden = true
                self.logoutButton.isHidden = false
            }
        } else {
            self.nameLabel.text = "ログインしていません"
            self.loginButton.isHidden = false
            self.logoutButton.isHidden = true
        }
        
        let baseStackView = UIStackView(arrangedSubviews: [nameLabel, lookButton, privacyButton, logoutButton, loginButton])
        baseStackView.spacing = 10
        baseStackView.axis = .vertical
        baseStackView.distribution = .fillEqually
        view.addSubview(baseStackView)
        baseStackView.anchor(left: view.leftAnchor, right: view.rightAnchor, centerY: view.centerYAnchor, leftPadding: 25, rightPadding: 25)
        logoutButton.anchor(height: 50)
    }
    
    private func setupBindings() {
        
        logoutButton.rx.tap
            .asDriver()
            .drive() { _ in
                self.logout()
            }
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .asDriver()
            .drive() { _ in
                self.login()
            }
            .disposed(by: disposeBag)
        
        privacyButton.rx.tap
            .asDriver()
            .drive() { _ in
                
            }
            .disposed(by: disposeBag)
        
        lookButton.rx.tap
            .asDriver()
            .drive() { _ in
                
            }
            .disposed(by: disposeBag)
        
    }
    
    private func logout() {
        guard let _ = Auth.auth().currentUser?.uid else { return }
        do {
            let firebaseAuth = Auth.auth()
            try firebaseAuth.signOut()
            let loginVC = LoginViewController()
            let nav = UINavigationController(rootViewController: loginVC)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        } catch let signOutError as NSError {
            print("Error siging out: %@", signOutError)
        }
    }
    
    private func login() {
        if Auth.auth().currentUser?.uid == nil {
            let loginVC = LoginViewController()
            let nav = UINavigationController(rootViewController: loginVC)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
    }

}
