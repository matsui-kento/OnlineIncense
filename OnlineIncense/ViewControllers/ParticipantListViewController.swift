//
//  ParticipantListViewController.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/14.
//

import UIKit
import Firebase
import PKHUD

class ParticipantListViewController: UIViewController {

    private let participantTableView = UITableView()
    var  participantArray = [Participant]()
    var documentID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "参列者一覧"
    }
    
    private func setupLayout() {
        
        view.backgroundColor = .white
        participantTableView.delegate = self
        participantTableView.dataSource = self
        
        Firestore.fetchParticipant(documentID: documentID) { participantArray in
            if participantArray != nil {
                self.participantArray = participantArray ?? [Participant]()
                self.participantTableView.reloadData()
            } else {
                HUD.flash(.labeledError(title: "エラーが発生しました。", subtitle: "もう一度やり直してください。\nもし何度やり直してもできない場合は開発者に連絡してください。"))
            }
        }
        
        participantTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(participantTableView)
        participantTableView.anchor(top: view.topAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, topPadding: 20, leftPadding: 25, rightPadding: 25)
    }
    
    private func setupBindings() {
        
    }

}

extension ParticipantListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return participantArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = participantTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchTableViewCell
        cell.nameLabel.text = participantArray[indexPath.row].name
        cell.placeLabel.text = participantArray[indexPath.row].relation
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = ParticipantDetailViewController()
        detailVC.nameDiscriptionLabel.text = participantArray[indexPath.row].name
        detailVC.addressDiscriptionLabel.text = participantArray[indexPath.row].address
        detailVC.numberDiscriptionLabel.text = participantArray[indexPath.row].number
        detailVC.companyDiscriptionLabel.text = participantArray[indexPath.row].company
        detailVC.relationDiscriptionLabel.text = participantArray[indexPath.row].relation
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
}
