//
//  SearchViewController.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/10.
//

import UIKit
import RxSwift
import RxCocoa
import PKHUD
import Firebase

class SearchViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let prefecturePickerView = PrefecturePickerView()
    private let nameTextField = CommonTextField(text: "故人(ひらがな)")
    private let prefectureTextField = CommonTextField(text: "都道府県")
    private let searchButton = ActionButton(text: "検索")
    private let searchTextLabel = SearchTextLabel()
    private let searchTableView = UITableView()
    var infoArray = [Info]()
    private let padding = Padding.shared
    
    private let screenSize: CGSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    private let prefectures = ["北海道", "青森県", "岩手県", "宮城県", "秋田県",
                               "山形県", "福島県", "茨城県", "栃木県", "群馬県",
                               "埼玉県", "千葉県", "東京都", "神奈川県","新潟県",
                               "富山県", "石川県", "福井県", "山梨県", "長野県",
                               "岐阜県", "静岡県", "愛知県", "三重県", "滋賀県",
                               "京都府", "大阪府", "兵庫県", "奈良県", "和歌山県",
                               "鳥取県", "島根県", "岡山県", "広島県", "山口県",
                               "徳島県", "香川県", "愛媛県", "高知県", "福岡県",
                               "佐賀県", "長崎県", "熊本県", "大分県", "宮崎県",
                               "鹿児島県", "沖縄県"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationItem.hidesBackButton = true
        self.parent?.navigationItem.hidesBackButton = true
        self.parent?.navigationItem.title = "香典・芳名録を探す"
    }
    
    private func setupLayout() {
        
        // デリゲートの設定
        nameTextField.delegate = self
        prefectureTextField.delegate = self
        prefecturePickerView.delegate = self
        prefecturePickerView.dataSource = self
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        //cellに名前を付ける
        searchTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "cell")
        
        // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 40))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        
        // インプットビュー設定
        prefectureTextField.inputView = prefecturePickerView
        prefectureTextField.inputAccessoryView = toolbar
        
        let searchStackView = UIStackView(arrangedSubviews: [nameTextField, prefectureTextField, searchButton, searchTextLabel])
        searchStackView.axis = .vertical
        searchStackView.distribution = .fillEqually
        searchStackView.spacing = 10
        
        let baseStackView = UIStackView(arrangedSubviews: [searchStackView, searchTableView])
        baseStackView.axis = .vertical
        baseStackView.spacing = 10
        view.addSubview(baseStackView)
        nameTextField.anchor(height: 50)
        searchTableView.anchor(height: 1000)
        baseStackView.anchor(top: view.topAnchor ,left: view.leftAnchor, right: view.rightAnchor, topPadding: padding.top, leftPadding: padding.left, rightPadding: padding.left)
        print(padding.screenHeight)
    }
    
    private func setupBindings() {
        
        searchButton.rx.tap
            .asDriver()
            .drive() { _ in
                self.searchInfo()
            }
            .disposed(by: disposeBag)
        
    }
    
    private func searchInfo() {
        
        guard let name = nameTextField.text else { return }
        guard let prefecture = prefectureTextField.text else { return }
        HUD.show(.progress)
        if (name != "") && (prefecture != "") {
            Firestore.fetchInfoForSeach(name: name, prefecture: prefecture) { infoArray in
                HUD.hide()
                if infoArray == nil {
                    HUD.flash(.labeledError(title: "エラーが起こりました。", subtitle: "開発者に連絡してください。"), delay: 1)
                } else {
                    self.infoArray = infoArray ?? [Info]()
                    self.searchTableView.reloadData()
                }
            }
        } else {
            HUD.flash(.labeledError(title: "検索エラー", subtitle: "名前と都道府県を入力してください。"), delay: 1)
        }
        
    }
    
    @objc func done() {
        prefectureTextField.endEditing(true)
        prefectureTextField.text = "\(prefectures[prefecturePickerView.selectedRow(inComponent: 0)])"
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in sampleTableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ sampleTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoArray.count
    }
    
    func tableView(_ sampleTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchTableViewCell
        cell.nameLabel.text = infoArray[indexPath.row].deceasedName
        cell.placeLabel.text = infoArray[indexPath.row].place
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        detailVC.deceasedDiscriptionLabel.text = infoArray[indexPath.row].deceasedName
        detailVC.homelessDiscriptionLabel.text = infoArray[indexPath.row].homeless
        detailVC.placeDiscriptionLabel.text = infoArray[indexPath.row].place
        detailVC.addressDiscriptionLabel.text = infoArray[indexPath.row].address
        detailVC.scheduleDiscriptionLabel.text = infoArray[indexPath.row].schedule
        detailVC.documentID = infoArray[indexPath.row].documentID
        detailVC.incense = infoArray[indexPath.row].incense
        detailVC.otherTextView.text = infoArray[indexPath.row].other
        detailVC.info = infoArray[indexPath.row]
        detailVC.writeButton.isHidden = false
        detailVC.rejectionDiscription.isHidden = false
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

extension SearchViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    // ドラムロールの列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // ドラムロールの行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return prefectures.count
    }
    
    // ドラムロールの各タイトル
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return prefectures[row]
    }
}

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
