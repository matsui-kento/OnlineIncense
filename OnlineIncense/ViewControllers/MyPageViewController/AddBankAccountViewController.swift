//
//  AddBankAccountViewController.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/19.
//

import RxSwift
import RxCocoa
import Firebase
import UIKit
import CurlDSL
import PKHUD

protocol AddBankAccountProtocol {
    func  addBankAccount(success: Bool)
}

class AddBankAccountViewController: UIViewController {
    
    var delegate: AddBankAccountProtocol?
    private let viewModel = AddBankAccountViewModel()
    private let disposeBag = DisposeBag()
    private let bankAccountnameLabel = CommonTitleLabel(label: "口座名義人")
    private let walletNumberLabel = CommonTitleLabel(label: "口座番号")
    private let branchCodeLabel = CommonTitleLabel(label: "支店コード")
    private let bankNumberLabel = CommonTitleLabel(label: "金融機関コード")
    private let bankNameLabel = CommonTitleLabel(label: "金融機関名")
    private let kindBankAccountLabel = CommonTitleLabel(label: "預金種別")
    private let typeLabel = CommonTitleLabel(label: "個人or会社")
    private let bankAccountnameTextField = CommonTextField(text: "口座名義人")
    private let bankAccountNumberTextField = CommonTextField(text: "口座番号")
    private let branchCodeTextField = CommonTextField(text: "支店コード")
    private let bankNameTextField = CommonTextField(text: "金融機関名")
    private let bankNumberTextField = CommonTextField(text: "金融機関コード")
    private let kindBankAccountTextField = CommonTextField(text: "普通/当座など")
    private let typeTextField = CommonTextField(text: "個人or会社")
    private let addButton = ActionButton(text: "追加する")
    private let errorDiscription = ErrorDiscription()
    private var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "振込先の追加"
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.fetchUser(uid: uid) { user in
            self.user = user
        }
        setupLayout()
        setupBindings()
    }
    
    
    private func setupLayout() {
        
        view.backgroundColor = .white
        let nameStackView = UIStackView(arrangedSubviews: [bankAccountnameLabel, bankAccountnameTextField])
        let walletNumberStackView = UIStackView(arrangedSubviews: [walletNumberLabel, bankAccountNumberTextField])
        let branchCodeStackView = UIStackView(arrangedSubviews: [branchCodeLabel, branchCodeTextField])
        let bankNumberStackView = UIStackView(arrangedSubviews: [bankNumberLabel, bankNumberTextField])
        let bankNameStackView = UIStackView(arrangedSubviews: [bankNameLabel, bankNameTextField])
        let kindBankAccountStackView = UIStackView(arrangedSubviews: [kindBankAccountLabel, kindBankAccountTextField])
        let typeStackView = UIStackView(arrangedSubviews: [typeLabel, typeTextField])
        let stackViews = [nameStackView, bankNumberStackView, bankNameStackView, branchCodeStackView, walletNumberStackView, kindBankAccountStackView, typeStackView]
        stackViews.forEach {
            $0.axis = .horizontal
            $0.spacing = 10
            $0.distribution = .fillEqually
        }
        
        let baseStackView = UIStackView(arrangedSubviews:  [nameStackView, bankNumberStackView, bankNameStackView, branchCodeStackView, kindBankAccountStackView, typeStackView, walletNumberStackView, addButton])
        baseStackView.axis = .vertical
        baseStackView.spacing = 20
        baseStackView.distribution = .fillEqually
        view.addSubview(baseStackView)
        bankAccountnameLabel.anchor(height:50)
        baseStackView.anchor(left: view.leftAnchor, right: view.rightAnchor, centerY: view.centerYAnchor, leftPadding: 25, rightPadding: 25)
        
        addButton.setTitleColor(.gray, for: .disabled)
    }
    
    private func setupBindings() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        bankNumberTextField.keyboardType = .numberPad
        branchCodeTextField.keyboardType = .numberPad
        bankAccountNumberTextField.keyboardType = .numberPad
        
        bankAccountnameTextField.rx.text
            .bind(to: viewModel.bankAccountNameSubject)
            .disposed(by: disposeBag)
        bankNumberTextField.rx.text
            .bind(to: viewModel.bankNumberSubject)
            .disposed(by: disposeBag)
        bankNameTextField.rx.text
            .bind(to: viewModel.bankNameSubject)
            .disposed(by: disposeBag)
        branchCodeTextField.rx.text
            .bind(to: viewModel.branchCodeSubject)
            .disposed(by: disposeBag)
        kindBankAccountTextField.rx.text
            .bind(to: viewModel.kindBankAccountSubject)
            .disposed(by: disposeBag)
        typeTextField.rx.text
            .bind(to: viewModel.typeSubject)
            .disposed(by: disposeBag)
        bankAccountNumberTextField.rx.text
            .bind(to: viewModel.bankAccountNumberSubject)
            .disposed(by: disposeBag)
        viewModel.isValidForm
            .bind(to: addButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .asDriver()
            .drive() { _ in
                self.addBankAccount()
            }
            .disposed(by: disposeBag)
        
    }
    
    private func addBankAccount() {
        guard let uid = Auth.auth().currentUser?.uid,
              let name = user?.name,
              let bankAccountName = bankAccountnameTextField.text,
              let bankNumber = bankNumberTextField.text,
              let bankName = bankNameTextField.text,
              let branchCode = branchCodeTextField.text,
              let kindBankAccount = kindBankAccountTextField.text,
              let type = typeTextField.text,
              let bankAccountNumber = bankAccountNumberTextField.text else { return }
        
        Firestore.setBankAccount(name: name,
                                 bankAccountName: bankAccountName,
                                 bankNumber: bankNumber,
                                 bankName: bankName,
                                 branchCode: branchCode,
                                 kindBankAccount: kindBankAccount,
                                 type: type,
                                 bankAccountNumber: bankAccountNumber,
                                 uid: uid) { success in
            
            if success {
                self.delegate?.addBankAccount(success: true)
                self.navigationController?.popViewController(animated: true)
            } else {
                HUD.flash(.labeledError(title: "エラーが発生しました。", subtitle: "App Storeから開発者に連絡してください。"), delay: 5)
            }
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if !kindBankAccountTextField.isFirstResponder,
           !typeTextField.isFirstResponder,
           !bankAccountNumberTextField.isFirstResponder {
            return
        }
        
        if self.view.frame.origin.y == 0 {
            if let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                self.view.frame.origin.y -= keyboardRect.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}


extension AddBankAccountViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
