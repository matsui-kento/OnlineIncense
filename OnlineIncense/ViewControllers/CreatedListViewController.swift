//
//  CreatedListViewController.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/14.
//

import UIKit
import Firebase

class CreatedListViewController: UIViewController {

    private let createdTableView = UITableView()
    var infoArray = [Info]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupBindinds()
    }

    private func setupLayout() {
        
        view.backgroundColor = .white
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.fetchInfoForMyPage(uid: uid) { infoArray in
            self.infoArray = infoArray ?? [Info]()
            self.createdTableView.reloadData()
        }
        
        createdTableView.delegate = self
        createdTableView.dataSource = self
        createdTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(createdTableView)
        createdTableView.anchor(top: view.topAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, topPadding: 20, leftPadding: 25, rightPadding: 25)
    }
    
    private func setupBindinds() {
        
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
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
    
    
}