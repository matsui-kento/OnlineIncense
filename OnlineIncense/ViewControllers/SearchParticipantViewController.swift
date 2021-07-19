//
//  SearchParticipantViewController.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/18.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase

protocol FilterArrayProtocol {
    func  filterArray(filterArray: [Participant]?)
}

class SearchParticipantViewController: UIViewController {
    
    var delegate:FilterArrayProtocol?
    private let disposeBag = DisposeBag()
    private let incenseButton = ActionButton(text: "香典有りの人を表示")
    private let withoutIncenseButton = ActionButton(text: "香典無しの人を表示")
    private let namaButton = ActionButton(text: "名前順に並べる")
    private let searchButton = ActionButton(text: "検索する")
    private let searchTextField = CommonTextField(text: "このワードで絞り込む")
    var participantArray = [Participant]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupBindings()
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        
        let buttonStackView = UIStackView(arrangedSubviews: [incenseButton, withoutIncenseButton, namaButton])
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 10
        buttonStackView.distribution = .fillEqually
        let searchStackView = UIStackView(arrangedSubviews: [searchTextField, searchButton])
        searchStackView.axis = .vertical
        searchStackView.spacing = 10
        searchStackView.distribution = .fillEqually
        let baseStackView = UIStackView(arrangedSubviews: [buttonStackView, searchStackView])
        baseStackView.axis = .vertical
        baseStackView.spacing = 50
        view.addSubview(baseStackView)
        incenseButton.anchor(height: 50)
        searchTextField.anchor(height: 50)
        baseStackView.anchor(left: view.leftAnchor, right: view.rightAnchor, centerY: view.centerYAnchor, leftPadding: 25, rightPadding: 25)
        
    }
    
    private func setupBindings() {
        
        incenseButton.rx.tap
            .asDriver()
            .drive() { _ in
                self.filterIncense()
            }
            .disposed(by: disposeBag)
        
        withoutIncenseButton.rx.tap
            .asDriver()
            .drive() { _ in
                self.filterWithoutIncense()
            }
            .disposed(by: disposeBag)
        
        namaButton.rx.tap
            .asDriver()
            .drive() { _ in
                self.orderByname()
            }
            .disposed(by: disposeBag)
        
        searchButton.rx.tap
            .asDriver()
            .drive() { _ in
                self.search()
            }
            .disposed(by: disposeBag)
    }
    
    private func filterIncense() {
        participantArray =  participantArray.filter { $0.incense != "香典なし" }
        delegate?.filterArray(filterArray: participantArray)
        dismiss(animated: true, completion: nil)
    }
    
    private func filterWithoutIncense() {
        participantArray =  participantArray.filter { $0.incense == "香典なし" }
        delegate?.filterArray(filterArray: participantArray)
        dismiss(animated: true, completion: nil)
    }
    
    private func orderByname() {
        participantArray = participantArray.sorted(by: { participant1, participant2 -> Bool in
            return participant1.hurigana < participant2.hurigana
        })
        delegate?.filterArray(filterArray: participantArray)
        dismiss(animated: true, completion: nil)
    }
    
    private func search() {
        let searchText = searchTextField.text ?? ""
        
        if searchText == "" {
            delegate?.filterArray(filterArray: participantArray)
            dismiss(animated: true, completion: nil)
            return
        }
        
        participantArray = participantArray.filter { ($0.name.contains(searchText)) || ($0.hurigana.contains(searchText)) || ($0.address.contains(searchText)) || ($0.company.contains(searchText)) || ($0.relation.contains(searchText)) }
        delegate?.filterArray(filterArray: participantArray)
        dismiss(animated: true, completion: nil)
        
    }
}

extension SearchParticipantViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
