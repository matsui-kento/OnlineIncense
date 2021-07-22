//
//  CreatedListViewController.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/14.
//

import UIKit
import Firebase
import PKHUD

class CreatedListViewController: UIViewController {

    let createdTableView = UITableView()
    var infoArray = [Info]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "香典・芳名録"
        
        setupLayout()
    }
    private func setupLayout() {
        
        view.backgroundColor = .white
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        fetchInfoFromMe(uid)
        
        createdTableView.delegate = self
        createdTableView.dataSource = self
        createdTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(createdTableView)
        createdTableView.anchor(top: view.topAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, topPadding: 20, leftPadding: 25, rightPadding: 25)
    }
    
    private func fetchInfoFromMe(_ uid: String) {
        Firestore.fetchInfoForMyPage(uid: uid) { infoArray in
            
            if infoArray != nil {
                self.infoArray = infoArray ?? [Info]()
                self.createdTableView.reloadData()
            } else {
                HUD.flash(.labeledError(title: "エラーが発生しました。", subtitle: "もう一度やり直してください。\nもし何度やり直してもできない場合は開発者に連絡してください。"))
            }
        }
    }

}

extension CreatedListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = createdTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchTableViewCell
        cell.nameLabel.text = infoArray[indexPath.row].deceasedName
        cell.placeLabel.text = infoArray[indexPath.row].place
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let funcListVC = FuncListViewController()
        funcListVC.delegate = self
        funcListVC.documentID = infoArray[indexPath.row].documentID
        funcListVC.incense = infoArray[indexPath.row].incense
        funcListVC.transfer = infoArray[indexPath.row].transfer
        funcListVC.info = infoArray[indexPath.row]
        self.navigationController?.pushViewController(funcListVC, animated: true)
    }
    
    
}

extension CreatedListViewController: deleteInfoProtocol {
    
    func deleteInfo(success: Bool) {
        if success {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            fetchInfoFromMe(uid)
            HUD.flash(.success, delay: 1)
        }
    }
    
}
