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
    private let logoutButton = ActionButton(text: "ログアウト")
    private let loginButton = ActionButton(text: "ログイン")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.parent?.navigationItem.title = "マイページ"
    }
    
    private func setupBindings() {
        let baseStackView = UIStackView(arrangedSubviews: [logoutButton, loginButton])
        baseStackView.spacing = 10
        baseStackView.axis = .vertical
        baseStackView.distribution = .fillEqually
        view.addSubview(baseStackView)
        baseStackView.anchor(left: view.leftAnchor, right: view.rightAnchor, centerY: view.centerYAnchor, leftPadding: 25, rightPadding: 25)
        logoutButton.anchor(height: 50)
    }
    
    private func setupLayout() {
        
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
