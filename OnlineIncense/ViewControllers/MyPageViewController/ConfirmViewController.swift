//
//  ConfirmViewController.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/21.
//

import UIKit
import Firebase
import RxSwift
import RxCocoa
import PKHUD

protocol TransferProtocol {
    func transfer(success: Bool)
}

class ConfirmViewController: UIViewController {

    var delegate: TransferProtocol?
    private let disposeBag = DisposeBag()
    private let transferButton = ImportantButton(text: "振込申請")
    private let incensePriceLabel = CommonTitleLabel(label: "香典総額")
    private let tansferPriceLabel = CommonTitleLabel(label: "振込金額")
    private let bankAccountNameLabel = CommonTitleLabel(label: "名義人")
    private let bankNameLabel = CommonTitleLabel(label: "金融機関名")
    private let branchCodeLabel = CommonTitleLabel(label: "支店コード")
    private let bankAccountNumberLabel = CommonTitleLabel(label: "口座番号")
    let incesnePriceDiscriptionLabel = DetailDiscriptionLabel(label: "")
    let tranferPriceDiscriptionLabel = DetailDiscriptionLabel(label: "")
    let bankAccountNameDiscriptionLabel = DetailDiscriptionLabel(label: "")
    let bankNameDiscriptionLabel = DetailDiscriptionLabel(label: "")
    let branchCodeDiscriptionLabel = DetailDiscriptionLabel(label: "")
    let bankAccountNumberDiscriptionLabel = DetailDiscriptionLabel(label: "")
    var info: Info?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupLayout()
        setupBindings()
    }

    private func setupLayout() {
        let incensePriceStackView = UIStackView(arrangedSubviews: [incensePriceLabel, incesnePriceDiscriptionLabel])
        let transferPriceStackView = UIStackView(arrangedSubviews: [tansferPriceLabel, tranferPriceDiscriptionLabel])
        let bankAccountNameStackView = UIStackView(arrangedSubviews: [bankAccountNameLabel, bankAccountNameDiscriptionLabel])
        let bankNameStackView = UIStackView(arrangedSubviews: [bankNameLabel, bankNameDiscriptionLabel])
        let branchCodeStackView = UIStackView(arrangedSubviews: [branchCodeLabel, branchCodeDiscriptionLabel])
        let bankAccountNumberStackView = UIStackView(arrangedSubviews: [bankAccountNumberLabel, bankAccountNumberDiscriptionLabel])
        let stackViews = [incensePriceStackView, transferPriceStackView, bankAccountNameStackView, bankNameStackView, branchCodeStackView, bankAccountNumberStackView]
        stackViews.forEach {
            $0.axis = .vertical
            $0.spacing = 0
            $0.distribution = .fillEqually
        }
        
        let baseStackView = UIStackView(arrangedSubviews: [incensePriceStackView, transferPriceStackView, bankAccountNameStackView, bankNameStackView, branchCodeStackView, bankAccountNumberStackView, transferButton])
        baseStackView.spacing = 20
        baseStackView.axis = .vertical
        view.addSubview(baseStackView)
        transferButton.anchor(height: 50)
        baseStackView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, topPadding: 120, leftPadding: 25, rightPadding: 25)
    }
    
    private func setupBindings() {
        
        transferButton.rx.tap
            .asDriver()
            .drive() { _ in
                self.transferConfirmActionSheet()
            }
            .disposed(by: disposeBag)
        
    }
    
    private func transferConfirmActionSheet() {
        guard let uid = Auth.auth().currentUser?.uid,
              let infoID = info?.documentID,
              let incensePrice = incesnePriceDiscriptionLabel.text,
              let transferPrice = tranferPriceDiscriptionLabel.text,
              let bankAccountName = bankAccountNameDiscriptionLabel.text,
              let bankName = bankNameDiscriptionLabel.text,
              let branchCode = branchCodeDiscriptionLabel.text,
              let bankAccountNumber = bankAccountNumberDiscriptionLabel.text else { return }
        
        let alert = UIAlertController(title: "振込申請する", message: "申請すると検索で表示されないようになります。", preferredStyle: .actionSheet)
        let transfer = UIAlertAction(title: "振込申請する", style: .destructive, handler: {
            (action: UIAlertAction!) in
            
            Firestore.setTransfer(incensePrice: incensePrice,
                                  transferPrice: transferPrice,
                                  bankAccountName: bankAccountName,
                                  bankName: bankName,
                                  branchCode: branchCode,
                                  bankAccountNumber: bankAccountNumber,
                                  uid: uid,
                                  infoID: infoID) { success in
                if success {
                    self.delegate?.transfer(success: true)
                    self.navigationController?.popViewControllers(viewsToPop: 4)
                } else {
                    HUD.flash(.labeledError(title: "エラーが発生しました。", subtitle: "App Storeから開発者に連絡してください。"), delay: 5)
                }
            }
            
        })
        alert.addAction(transfer)
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
