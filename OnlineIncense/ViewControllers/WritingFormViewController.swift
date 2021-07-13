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

class WritingFormViewController: UIViewController {

    private let nameLabel = CommonTitleLabel(label: "御芳名(代表者)")
    private let addressLabel = CommonTitleLabel(label: "住所")
    private let numberLabel = CommonTitleLabel(label: "電話")
    private let companyLabel = CommonTitleLabel(label: "会社名/団体名(任意)")
    private let relationLabel = CommonTitleLabel(label: "ご関係")
    
    private let nameTextField = CommonTextField(text: "御芳名(代表者)")
    private let addressTextField = CommonTextField(text: "住所")
    private let numberTextField = CommonTextField(text: "電話")
    private let companyTextField = CommonTextField(text: "会社名/団体名(任意)")
    private let relationTextField = CommonTextField(text: "ご関係")
    
    private let spaceView = CommonTitleLabel(label: "")
    private let doneButton = ActionButton(text: "記入完了")
    private let scrollView = UIScrollView()
    
    private let screenSize: CGSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    private let viewModel = CreateFormViewModel()
    private let disposeBag = DisposeBag()
    
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
        let addressStackView = UIStackView(arrangedSubviews: [addressLabel, addressTextField])
        let numberStackView = UIStackView(arrangedSubviews: [numberLabel, numberTextField])
        let companyStackView = UIStackView(arrangedSubviews: [companyLabel, companyTextField])
        let relationStackView = UIStackView(arrangedSubviews: [relationLabel, relationTextField])
        let stackViews = [nameStackView, addressStackView, numberStackView, companyStackView, relationStackView]
        stackViews.forEach {
            $0.axis = .vertical
            $0.spacing = 0
            $0.distribution = .fillEqually
        }
        
        let baseStackView = UIStackView(arrangedSubviews: [nameStackView, addressStackView, numberStackView, companyStackView, relationStackView, spaceView, doneButton])
        baseStackView.axis = .vertical
        baseStackView.spacing = 10
        
        scrollView.frame = self.view.frame
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 2000)
        view.addSubview(scrollView)
        scrollView.anchor(top: view.topAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        scrollView.addSubview(baseStackView)
        
        nameLabel.anchor(width: screenSize.width - 50, height: 50)
        addressLabel.anchor(height: 50)
        numberLabel.anchor(height: 50)
        companyLabel.anchor(height: 50)
        relationLabel.anchor(height: 50)
        doneButton.anchor(height: 50)
        spaceView.anchor(height: 5)
        
        baseStackView.anchor(top: scrollView.topAnchor, bottom: scrollView.bottomAnchor, left: scrollView.leftAnchor, right: scrollView.rightAnchor, leftPadding: 25, rightPadding: 25)
        
    }
    
    private func setupBindings() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        doneButton.rx.tap
            .asDriver()
            .drive() { _ in
                
            }
            .disposed(by: disposeBag)
        
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