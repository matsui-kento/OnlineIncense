//
//  WritingFormViewController.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/13.
//

import UIKit
import RxSwift
import RxCocoa
import PKHUD
import Firebase

class WritingFormViewController: UIViewController {

    private let nameLabel = CommonTitleLabel(label: "御芳名(代表者) *必須")
    private let huriganaLabel = CommonTitleLabel(label: "御芳名(フリガナ) *必須")
    private let addressLabel = CommonTitleLabel(label: "住所 *必須")
    private let numberLabel = CommonTitleLabel(label: "電話 *必須")
    private let companyLabel = CommonTitleLabel(label: "会社名/団体名(任意)")
    private let relationLabel = CommonTitleLabel(label: "ご関係(友人/会社/親戚など) *必須")
    
    private let nameTextField = CommonTextField(text: "御芳名(代表者)")
    private let huriganaTextField = CommonTextField(text: "御芳名(フリガナ)")
    private let addressTextField = CommonTextField(text: "住所")
    private let numberTextField = CommonTextField(text: "電話")
    private let companyTextField = CommonTextField(text: "会社名/団体名(任意)")
    private let relationTextField = CommonTextField(text: "ご関係")
    
    private let spaceView = CommonTitleLabel(label: "")
    private let doneButton = ActionButton(text: "記入完了")
    private let scrollView = UIScrollView()
    
    private let screenSize: CGSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    private let viewModel = WritingFormViewModel()
    private let disposeBag = DisposeBag()
    var info: Info?
    var documentID = ""
    var participantID = ""
    var insence = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupBindings()
    }
    
    private func setupLayout() {
        
        view.backgroundColor = .white
        spaceView.backgroundColor = .clear
        
        let textFields = [nameTextField, addressTextField, numberTextField, companyTextField, relationTextField]
        textFields.forEach {
            $0.delegate = self
        }
        
        let nameStackView = UIStackView(arrangedSubviews: [nameLabel, nameTextField])
        let huriganaStackView = UIStackView(arrangedSubviews: [huriganaLabel, huriganaTextField])
        let addressStackView = UIStackView(arrangedSubviews: [addressLabel, addressTextField])
        let numberStackView = UIStackView(arrangedSubviews: [numberLabel, numberTextField])
        let companyStackView = UIStackView(arrangedSubviews: [companyLabel, companyTextField])
        let relationStackView = UIStackView(arrangedSubviews: [relationLabel, relationTextField])
        let stackViews = [nameStackView, huriganaStackView, addressStackView, numberStackView, companyStackView, relationStackView]
        stackViews.forEach {
            $0.axis = .vertical
            $0.spacing = 0
            $0.distribution = .fillEqually
        }
        
        let baseStackView = UIStackView(arrangedSubviews: [nameStackView, huriganaStackView, addressStackView, numberStackView, companyStackView, relationStackView, spaceView, doneButton])
        baseStackView.axis = .vertical
        baseStackView.spacing = 10
        
        scrollView.frame = self.view.frame
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 2000)
        view.addSubview(scrollView)
        scrollView.anchor(top: view.topAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        scrollView.addSubview(baseStackView)
        
        nameLabel.anchor(width: screenSize.width - 50, height: 50)
        addressLabel.anchor(height: 50)
        huriganaLabel.anchor(height: 50)
        numberLabel.anchor(height: 50)
        companyLabel.anchor(height: 50)
        relationLabel.anchor(height: 50)
        doneButton.anchor(height: 50)
        spaceView.anchor(height: 5)
        
        baseStackView.anchor(top: scrollView.topAnchor, bottom: scrollView.bottomAnchor, left: scrollView.leftAnchor, right: scrollView.rightAnchor, leftPadding: 25, rightPadding: 25)
        
        doneButton.setTitleColor(.gray, for: .disabled)
        
    }
    
    private func setupBindings() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        nameTextField.rx.text
            .bind(to: viewModel.nameSubject)
            .disposed(by: disposeBag)
        huriganaTextField.rx.text
            .bind(to: viewModel.huriganaSubject)
            .disposed(by: disposeBag)
        addressTextField.rx.text
            .bind(to: viewModel.addressSubject)
            .disposed(by: disposeBag)
        numberTextField.rx.text
            .bind(to: viewModel.numberSubject)
            .disposed(by: disposeBag)
        relationTextField.rx.text
            .bind(to: viewModel.relationSubject)
            .disposed(by: disposeBag)
        viewModel.isValidForm
            .bind(to: doneButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        doneButton.rx.tap
            .asDriver()
            .drive() { _ in
                self.sendInfo()
            }
            .disposed(by: disposeBag)
        
    }
    
    private func sendInfo() {
        
        HUD.show(.progress)
        if nameTextField.text != "" &&
            huriganaTextField.text != "" &&
            addressTextField.text != "" &&
            numberTextField.text != "" &&
            relationTextField.text != "" {
            Firestore.setParticipant(name: nameTextField.text!,
                                     hurigana: huriganaTextField.text!,
                                     address: addressTextField.text!,
                                     number: numberTextField.text!,
                                     company: companyTextField.text ?? "個人",
                                     relation: relationTextField.text!,
                                     documentID: documentID) { participantID in
                if participantID != "" {
                    self.participantID = participantID
                    HUD.flash(.success)
                    self.insenceOrNot()
                } else {
                    HUD.flash(.labeledError(title: "芳名録の記入に失敗しました", subtitle: "必須項目を全て記入しているか確認してください。"), delay: 3)
                }
                }
            }
    }
    
    private func insenceOrNot() {
        if insence {
            let insenceFormVC = IncenseFormViewController()
            insenceFormVC.info = info
            insenceFormVC.infoID = documentID
            insenceFormVC.participantID = participantID
            self.navigationController?.pushViewController(insenceFormVC, animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if !relationTextField.isFirstResponder {
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

extension WritingFormViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
