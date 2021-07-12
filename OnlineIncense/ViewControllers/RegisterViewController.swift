//
//  RegisterViewController.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/10.
//

import UIKit
import PKHUD
import RxSwift
import RxCocoa
import Firebase

class RegisterViewController: UIViewController {

    private let viewModel = RegisterViewModel()
    private let disposeBag = DisposeBag()
    private let nameTextField = AuthTextField(text: "名前(利用者様)")
    private let emailTextField = AuthTextField(text: "メールアドレス")
    private let passwordTextField = AuthTextField(text: "パスワード")
    private let registerButton = ActionButton(text: "新規登録")
    private let haveAcountButton = AuthTextButton(label: "すでにアカウントをお持ちの方はこちら")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        view.addBackground(imageName: "Flower2")
        setupLayout()
        setupBindings()
    }
    
    private func setupLayout() {
        
        passwordTextField.isSecureTextEntry = true
        
        let baseStackView = UIStackView(arrangedSubviews: [nameTextField, emailTextField, passwordTextField, registerButton])
        baseStackView.axis = .vertical
        baseStackView.spacing = 25
        baseStackView.distribution = .fillEqually
        view.addSubview(baseStackView)
        view.addSubview(haveAcountButton)
        baseStackView.anchor(left: view.leftAnchor, right: view.rightAnchor, centerY: view.centerYAnchor, leftPadding: 25, rightPadding: 25)
        emailTextField.anchor(height: 50)
        haveAcountButton.anchor(bottom: view.bottomAnchor, centerX: view.centerXAnchor, bottomPadding: 100)
        
        registerButton.setTitleColor(.black, for: .disabled)
    }

    private func setupBindings() {
        
        nameTextField.rx.text
            .bind(to: viewModel.nameSubject)
            .disposed(by: disposeBag)
        emailTextField.rx.text
            .bind(to: viewModel.emailSubject)
            .disposed(by: disposeBag)
        passwordTextField.rx.text
            .bind(to: viewModel.passwordSubject)
            .disposed(by: disposeBag)
        viewModel.isValidForm
            .bind(to: registerButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        registerButton.rx.tap
            .asDriver()
            .drive() { _ in
                self.registerUser()
            }
            .disposed(by: disposeBag)
        
        haveAcountButton.rx.tap
            .asDriver()
            .drive() { _ in
                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
    }
    
    private func registerUser() {
        
        guard let name = self.nameTextField.text,
              let email = self.emailTextField.text,
              let password = self.passwordTextField.text else { return }
        HUD.show(.progress)
        Auth.createUserWithFirestore(name: name, email: email, password: password) { success in
            HUD.hide()
            if success {
                HUD.flash(.success, delay: 1)
                let mainTabVC = MainTabViewController()
                self.navigationController?.pushViewController(mainTabVC, animated: true)
            } else {
                HUD.flash(.labeledError(title: "登録に失敗しました", subtitle: "メールアドレスがすでに登録されている、もしくはメールアドレスが間違えています。"), delay: 3)
            }
        }
    }
}

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
