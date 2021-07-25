//
//  IncenseFormViewController.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/14.
//
import Foundation
import UIKit
import OmiseSDK
import RxSwift
import RxCocoa
import PKHUD
import Firebase
import Alamofire
import SwiftyJSON
import CurlDSL


class IncenseFormViewController: UIViewController {
    
    private let omise = Omise.shared
    private let disposeBag = DisposeBag()
    private let moneyLabel = DetailDiscriptionLabel(label: "金額")
    private let moneyTextField = CommonTextField(text: "香典の金額")
    private let payButton = ActionButton(text: "香典を贈る")
    private let notPayButton = ActionButton(text: "香典を贈らない")
    private let errorDiscription = ErrorDiscription()
    var infoID = ""
    var participantID = ""
    //var participant: Participant?
    var info: Info?
    var token: Token?
    var price = "0"
    var priceInt = 0
    var errorMessage: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "香典を贈る"
        refresh()
    }
    
    
    private func setupLayout() {
        self.navigationItem.hidesBackButton = true
        view.backgroundColor = .white
        moneyTextField.keyboardType = .numberPad
        
        let baseStackView = UIStackView(arrangedSubviews: [moneyLabel, errorDiscription ,moneyTextField, payButton, notPayButton])
        baseStackView.axis = .vertical
        baseStackView.spacing = 10
        
        view.addSubview(baseStackView)
        moneyTextField.anchor(height: 50)
        payButton.anchor(height: 50)
        notPayButton.anchor(height: 50)
        //errorDiscription.anchor(height: 50)
        baseStackView.anchor(left: view.leftAnchor, right: view.rightAnchor, centerY: view.centerYAnchor, leftPadding: 25, rightPadding: 25)
    }
    
    private func setupBindings() {
        
        payButton.rx.tap
            .asDriver()
            .drive() { _ in
                self.payAction()
            }
            .disposed(by: disposeBag)
        
        notPayButton.rx.tap
            .asDriver()
            .drive() { _ in
                self.notPayAction()
            }
            .disposed(by: disposeBag)
        
    }
    
    private func notPayAction() {
        Firestore.updateIncenseForParticipant(incense: "0", infoID: self.infoID, participantID: self.participantID) { success in
            if success {
                HUD.flash(.success, delay: 1)
                let mainVC = MainTabViewController()
                self.navigationController?.pushViewController(mainVC, animated: true)
            } else {
                HUD.flash(.labeledError(title: "エラーが起きました", subtitle: "App Storeから開発者に連絡してください。"), delay: 1)
            }
        }
    }
    
    private func payAction() {
        errorMessage = nil
        price = moneyTextField.text ?? "0"
        
        if price == "" || price == "0" {
            return
        } else {
            priceInt = Int(price)!
        }
        
        let creditCardView = CreditCardFormViewController.makeCreditCardFormViewController(withPublicKey: omise.publicKey)
        creditCardView.delegate = self
        creditCardView.handleErrors = true
        present(creditCardView, animated: true, completion: nil)
        
    }
    
    private func refresh() {
        if errorMessage == nil {
            errorDiscription.isHidden = true
            
        } else {
            errorDiscription.isHidden = false
            switch errorMessage {
            case "confirmed_amount_mismatch":
                errorDiscription.text = "支払いチャネルからの最終金額が元の請求金額と一致しません。"
            case "failed_fraud_check":
                errorDiscription.text = "このカードは不正なカードとしてマークされました。"
            case "failed_processing":
                errorDiscription.text = "支払い処理に失敗しました。もう一度お試しになるか、カードを変えてください。"
            case "insufficient_balance":
                errorDiscription.text = "クレジットの上限に達した、もしくはお金が足りません。"
            case "insufficient_fund":
                errorDiscription.text = "クレジットの上限に達した、もしくはお金が足りません。"
            case "invalid_account_number":
                errorDiscription.text = "有効なアカウントが見つかりません。カード情報をもう一度、確認してください。"
            case "invalid_account":
                errorDiscription.text = "有効なアカウントが見つかりません。カード情報をもう一度、確認してください。"
            case "invalid_security_code":
                errorDiscription.text = "セキュリティコードが間違えているか無効です。カード情報をもう一度、確認してください。"
            case "payment_cancelled":
                errorDiscription.text = "支払いがキャンセルされました。"
            case "payment_rejected":
                errorDiscription.text = "カードの発行者によって支払いが拒否されました。カード会社に連絡するか別のカードをご利用ください。"
            case "stolen_or_lost_card":
                errorDiscription.text = "このカードは紛失もしくは盗難されたものです。紛失・盗難されたカードはご利用できません。"
            case "timeout":
                errorDiscription.text = "支払いの有効期限が切れました。もう一度、お試しください。"
            case .none:
                errorDiscription.text = ""
            case .some(_):
                errorDiscription.text = ""
            }
        }
    }
}


extension IncenseFormViewController: CreditCardFormViewControllerDelegate {
    
    func creditCardFormViewControllerDidCancel(_ controller: CreditCardFormViewController) {
        dismiss(animated: true, completion: nil)
        
    }
    
    func creditCardFormViewController(_ controller: CreditCardFormViewController, didSucceedWithToken token: Token) {
        self.token = token
        let parameters = ["amount": priceInt,
                          "currency": "jpy",
                          "card": token.id] as [String : Any]
        createCharge(parameters)
        
    }
    
    func createCharge(_ parameters: [String : Any]) {
        let semaphore = DispatchSemaphore(value: 0)
        let url = URL(string: "https://api.omise.co/charges")!
        let session = URLSession.shared
        var request = try? CURL("curl -X POST -u \(omise.secretKey): https://api.omise.co/charges").buildRequest()
        request?.httpMethod = "POST"
        do {
            request?.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        request?.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request?.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = session.dataTask(with: (request ?? URLRequest(url: url)) as URLRequest, completionHandler: { data, response, error in
            guard error == nil else { return }
            guard let data = data else { return }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    let error = json["failure_code"] as? String
                    self.errorMessage = error
                    semaphore.signal()
                }
            } catch {
                
            }
        })
        task.resume()
        
        semaphore.wait()
        
        if errorMessage == nil {
            HUD.flash(.success)
            dismiss(animated: true, completion: nil)
            Firestore.updateIncenseForParticipant(incense: price, infoID: infoID, participantID: participantID) { success in
                if success {
                    Firestore.updateIncenseForInfo(infoID: self.infoID, newIncensePrice: self.priceInt)
                    self.navigationController?.popViewControllers(viewsToPop: 2)
                }
            }
        } else {
            dismiss(animated: true) {
                self.refresh()
            }
        }
    }
    
    func creditCardFormViewController(_ controller: CreditCardFormViewController, didFailWithError error: Error) {
        dismiss(animated: true, completion: nil)
    }
}

extension IncenseFormViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
