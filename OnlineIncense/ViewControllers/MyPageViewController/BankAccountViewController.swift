//
//  BankAccountViewController.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/19.
//
import RxSwift
import RxCocoa
import Firebase
import UIKit
import PKHUD

class BankAccountViewController: UIViewController {
    

    private let disposeBag = DisposeBag()
    private let addBankAccountButton = ActionButton(text: "振込先を追加する")
    private let padding = Padding.shared
    let bankAccountTableView = UITableView()
    var bankAccountArray = [BankAccount]()
    var info: Info?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "振込先を選ぶ"
    }
    
    private func setupLayout() {
        
        view.backgroundColor = .white
        bankAccountTableView.delegate = self
        bankAccountTableView.dataSource = self
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        fetchBankAcountArray(uid)
        
        bankAccountTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "cell")
        
        let baseStackView = UIStackView(arrangedSubviews: [addBankAccountButton, bankAccountTableView])
        baseStackView.axis = .vertical
        baseStackView.spacing = 10
        view.addSubview(baseStackView)
        addBankAccountButton.anchor(height: 50)
        baseStackView.anchor(top: view.topAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, topPadding: padding.top, leftPadding: padding.left, rightPadding: padding.right)
        bankAccountTableView.reloadData()
    }
    
    private func setupBindings() {
        
        addBankAccountButton.rx.tap
            .asDriver()
            .drive() { _ in
                self.toAddBankAccount()
            }
            .disposed(by: disposeBag)
        
    }
    
    private func fetchBankAcountArray(_ uid: String) {
        Firestore.fetchBankAccount(uid: uid) { bankAccountArray in
            if bankAccountArray != nil {
                self.bankAccountArray = bankAccountArray ?? [BankAccount]()
                self.bankAccountTableView.reloadData()
            } else if bankAccountArray == nil {
                HUD.flash(.labeledError(title: "エラーが発生しました。", subtitle: "もう一度やり直してください。\nもし何度やり直してもできない場合は開発者に連絡してください。"))
            }
        }
    }
    
    private func toAddBankAccount() {
        let addBankAccountVC = AddBankAccountViewController()
        addBankAccountVC.delegate = self
        self.navigationController?.pushViewController(addBankAccountVC, animated: true)
    }

}

extension BankAccountViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bankAccountArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = bankAccountTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchTableViewCell
        cell.nameLabel.text = bankAccountArray[indexPath.row].bankAccountName
        cell.placeLabel.text = bankAccountArray[indexPath.row].bankName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let confirmVC = ConfirmViewController()
        confirmVC.delegate = self
        confirmVC.incesnePriceDiscriptionLabel.text = "\(String(describing: info?.incensePrice ?? 0))円"
        let tranferPrice = (info?.incensePrice ?? 0) * 9 / 10
        confirmVC.tranferPriceDiscriptionLabel.text = "\(String(describing: tranferPrice))円"
        confirmVC.bankAccountNameDiscriptionLabel.text = bankAccountArray[indexPath.row].bankAccountName
        confirmVC.bankNameDiscriptionLabel.text = bankAccountArray[indexPath.row].bankName
        confirmVC.branchCodeDiscriptionLabel.text = bankAccountArray[indexPath.row].branchCode
        confirmVC.bankAccountNumberDiscriptionLabel.text = bankAccountArray[indexPath.row].bankAccountNumber
        confirmVC.info = info
        self.navigationController?.pushViewController(confirmVC, animated: true)
    }
}

extension BankAccountViewController: AddBankAccountProtocol {
    
    func addBankAccount(success: Bool) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        fetchBankAcountArray(uid)
        bankAccountTableView.reloadData()
        HUD.flash(.success, delay: 1)
    }
    
}

extension BankAccountViewController: TransferProtocol {
    func transfer(success: Bool) {
        if success {
            HUD.flash(.success, delay: 1)
        }
    }
}
