//
//  CreateFormViewController.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/11.
//

import UIKit
import PKHUD
import RxCocoa
import RxSwift
import Firebase
import FirebaseFirestore

class CreateFormViewController: UIViewController {
    
    private let viewModel = CreateFormViewModel()
    private let disposeBag = DisposeBag()
    private let prefecturePickerView = PrefecturePickerView()
    private let deceasedNameLabel = CommonTitleLabel(label: "故人")
    private let deceasedHiraganaLabel = CommonTitleLabel(label: "故人(ひらがな)")
    private let homelessLabel = CommonTitleLabel(label: "喪家")
    private let prefectureLabel = CommonTitleLabel(label: "出身地(都道府県のみ)")
    private let placeLabel = CommonTitleLabel(label: "式場")
    private let addressLabel = CommonTitleLabel(label: "式場住所")
    private let scheduleLabel = CommonTitleLabel(label: "日程")
    private let deceasedNameTextField = CommonTextField(text: "故人")
    private let deceasedHiraganaTextField = CommonTextField(text: "故人(ひらがな)")
    private let homelessTextField = CommonTextField(text: "喪家")
    private let prefectureTextField = CommonTextField(text: "出身地(都道府県のみ)")
    private let placeTextField = CommonTextField(text: "式場")
    private let addressTextField = CommonTextField(text: "住所")
    private let scheduleTextField = CommonTextField(text: "日程")
    private let createButton = ActionButton(text: "芳名録を作成する")
    private let scrollView = UIScrollView()
    private let spaceView = CommonTitleLabel(label: "")
    
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
        
        view.backgroundColor = .white
        setupLayout()
        setupBindings()
    }
    
    private func setupLayout() {
        
        spaceView.backgroundColor = .clear
        // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 40))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        
        // インプットビュー設定
        prefectureTextField.inputView = prefecturePickerView
        prefectureTextField.inputAccessoryView = toolbar
        
        prefecturePickerView.delegate = self
        prefecturePickerView.dataSource = self
        
        let textFields = [deceasedNameTextField, deceasedHiraganaTextField, homelessTextField, prefectureTextField, placeTextField, addressTextField, scheduleTextField]
        textFields.forEach {
            $0.delegate = self
        }
        
        let deceasedStackView = UIStackView(arrangedSubviews: [deceasedNameLabel, deceasedNameTextField])
        let deceasedHiraganaStackView = UIStackView(arrangedSubviews: [deceasedHiraganaLabel, deceasedHiraganaTextField])
        let homelessStackView = UIStackView(arrangedSubviews: [homelessLabel, homelessTextField])
        let prefectureStackView = UIStackView(arrangedSubviews: [prefectureLabel, prefectureTextField])
        let placeStackView = UIStackView(arrangedSubviews: [placeLabel, placeTextField])
        let addressStackView = UIStackView(arrangedSubviews: [addressLabel, addressTextField])
        let scheduleStackView = UIStackView(arrangedSubviews: [scheduleLabel, scheduleTextField])
        let stackViews = [deceasedStackView, deceasedHiraganaStackView, homelessStackView, prefectureStackView ,placeStackView, addressStackView, scheduleStackView]
        stackViews.forEach {
            $0.axis = .vertical
            $0.spacing = 0
            $0.distribution = .fillEqually
        }
        
        let baseStackView = UIStackView(arrangedSubviews: [deceasedStackView, deceasedHiraganaStackView, homelessStackView, prefectureStackView ,placeStackView, addressStackView, scheduleStackView, spaceView, createButton])
        baseStackView.axis = .vertical
        baseStackView.spacing = 10
        
        scrollView.frame = self.view.frame
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 2000)
        view.addSubview(scrollView)
        scrollView.anchor(top: view.topAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        scrollView.addSubview(baseStackView)
        
        deceasedNameLabel.anchor(width: screenSize.width - 50, height: 50)
        deceasedHiraganaLabel.anchor(height: 50)
        prefectureLabel.anchor(height: 50)
        homelessLabel.anchor(height: 50)
        placeLabel.anchor(height: 50)
        addressLabel.anchor(height: 50)
        scheduleLabel.anchor(height: 50)
        createButton.anchor(height: 50)
        spaceView.anchor(height: 5)
        
        baseStackView.anchor(top: scrollView.topAnchor, bottom: scrollView.bottomAnchor, left: scrollView.leftAnchor, right: scrollView.rightAnchor, leftPadding: 25, rightPadding: 25)
        
        createButton.setTitleColor(.black, for: .disabled)
    }
    
    private func setupBindings() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        deceasedNameTextField.rx.text
            .bind(to: viewModel.deceasedNameSubject)
            .disposed(by: disposeBag)
        deceasedHiraganaTextField.rx.text
            .bind(to: viewModel.deceasedHiraganaSubject)
            .disposed(by: disposeBag)
        homelessTextField.rx.text
            .bind(to: viewModel.homelessSubject)
            .disposed(by: disposeBag)
        placeTextField.rx.text
            .bind(to: viewModel.placeSubject)
            .disposed(by: disposeBag)
        addressTextField.rx.text
            .bind(to: viewModel.addressSubject)
            .disposed(by: disposeBag)
        scheduleTextField.rx.text
            .bind(to: viewModel.scheduleSubject)
            .disposed(by: disposeBag)
        viewModel.isValidForm
            .bind(to: createButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        createButton.rx.tap
            .asDriver()
            .drive() { _ in
                print("タップされたよ")
                self.sendInfo()
            }
            .disposed(by: disposeBag)
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if !scheduleTextField.isFirstResponder,
           !addressTextField.isFirstResponder,
           !placeTextField.isFirstResponder{
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
    
    @objc func done() {
        prefectureTextField.endEditing(true)
        prefectureTextField.text = "\(prefectures[prefecturePickerView.selectedRow(inComponent: 0)])"
    }
    
    
    private func sendInfo() {
        
        HUD.show(.progress)
        print("処理が始める")
        if deceasedNameTextField.text != "" &&
            deceasedHiraganaTextField.text != "" &&
            homelessTextField.text != "" &&
            prefectureTextField.text != "" &&
            placeTextField.text != "" &&
            addressTextField.text != "" &&
            scheduleTextField.text != "" {
            
            Firestore.setInfoWithoutIncense(deceasedName: deceasedNameTextField.text!,
                                            deceasedHiragana: deceasedHiraganaTextField.text!,
                                            homeless: homelessTextField.text!,
                                            prefecture: prefectureTextField.text!,
                                            place: placeTextField.text!,
                                            address: addressTextField.text!,
                                            schedule: scheduleTextField.text!,
                                            incense: false) { success in
                HUD.hide()
                if success {
                    HUD.flash(.success, delay: 1)
                    self.navigationController?.popViewController(animated: true)
                } else {
                    HUD.flash(.labeledError(title: "作成に失敗しました", subtitle: "全て正確に記入できている確認してください"), delay: 3)
                }
            }
        } else {
            HUD.flash(.labeledError(title: "作成に失敗しました", subtitle: "全て正確に記入できている確認してください"), delay: 2.5)
        }
    }
}

extension CreateFormViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
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

extension CreateFormViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
