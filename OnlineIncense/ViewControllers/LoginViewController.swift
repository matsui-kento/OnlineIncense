//
//  LoginViewController.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/10.
//

import UIKit
import PKHUD
import RxSwift
import RxCocoa
import Firebase

class LoginViewController: UIViewController {
    
    private let viewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    private let emailTextField = AuthTextField(text: "メールアドレス")
    private let passwordTextField = AuthTextField(text: "パスワード")
    private let loginButton = ActionButton(text: "ログイン")
    private let dontHaveAcountButton = AuthTextButton(label: "アカウントをお持ちでない方はこちら")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        view.addBackground(imageName: "Flower1")
        setupLayout()
        setupBindings()
    }
    
    private func setupLayout() {
        
        passwordTextField.isSecureTextEntry = true
        
        let baseStackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        baseStackView.axis = .vertical
        baseStackView.spacing = 25
        baseStackView.distribution = .fillEqually
        view.addSubview(baseStackView)
        view.addSubview(dontHaveAcountButton)
        baseStackView.anchor(left: view.leftAnchor, right: view.rightAnchor, centerY: view.centerYAnchor, leftPadding: 25, rightPadding: 25)
        emailTextField.anchor(height: 50)
        dontHaveAcountButton.anchor(bottom: view.bottomAnchor, centerX: view.centerXAnchor, bottomPadding: 100)
        
        loginButton.setTitleColor(.black, for: .disabled)
    }
    
    private func setupBindings() {
        
        emailTextField.rx.text
            .bind(to: viewModel.emailSubject)
            .disposed(by: disposeBag)
        passwordTextField.rx.text
            .bind(to: viewModel.passwordSubject)
            .disposed(by: disposeBag)
        viewModel.isValidForm
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .asDriver()
            .drive() { _ in
                print("タップされた")
                self.login()
            }
            .disposed(by: disposeBag)
        
        dontHaveAcountButton.rx.tap
            .asDriver()
            .drive() { _ in
                let registerVC = RegisterViewController()
                self.navigationController?.pushViewController(registerVC, animated: true)
            }
            .disposed(by: disposeBag)
        
    }
    
    private func login() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        HUD.show(.progress)
        Auth.loginUser(email: email, password: password) { success in
            if success {
                HUD.flash(.success, delay: 1)
                //self.navigationController?.popViewController(animated: true)
                let mainVC = MainTabViewController()
                self.navigationController?.pushViewController(mainVC, animated: true)
            } else {
                HUD.flash(.labeledError(title: "ログインに失敗しました", subtitle: "メールアドレスもしくはパスワードが間違えています。"), delay: 2.5)
            }
        }
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
