//
//  PrivacyPolicyViewController.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/29.
//

import UIKit

class PrivacyPolicyViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let policyTitleLabel1 = PolicyTitleLabel(label: "はじめに")
    private let policyTitleLabel2 = PolicyTitleLabel(label: "収集する情報")
    private let policyTitleLabel3 = PolicyTitleLabel(label: "個人情報の管理")
    private let policyTitleLabel4 = PolicyTitleLabel(label: "第三者への開示・提供の禁止")
    private let policyTitleLabel5 = PolicyTitleLabel(label: "法令、規範の遵守")
    private let policyTitleLabel6 = PolicyTitleLabel(label: "免責事項")
    private let policyTitleLabel7 = PolicyTitleLabel(label: "連絡先")
    private let policyTextView1 = PolicyTextView(textString: "本アプリのご使用によって、本規約に同意していただいたものとみなします。")
    private let policyTextView2 = PolicyTextView(textString: "【アカウントを作成する場合】\nユーザー名、メールアドレス\n【芳名録を作成する場合】\n名前、出身地(都道府県)、喪家、式場、式場住所、お通夜の日程\n芳名録を作成する場合は、他ユーザーが検索するさいに、名前と出身地(都道府県)を一致させると、上記の情報が見られます。しかし、両方が一致しないと検索に引っかからないようにしており、誰でも見られるわけではございません。\n【芳名録を記入する場合】\n名前、住所、電話番号、故人との関係、会社名(任意)\n【アプリ上で香典を贈る場合】\nお支払い情報\n【アプリ上で香典を受け取る場合】\n口座振込に必要な情報")
    private let policyTextView3 = PolicyTextView(textString: "当方は、お客さまの個人情報を正確かつ最新の状態に保ち、個人情報への不正アクセス・紛失・破損・改ざん・漏洩などを防止するため、安全対策を実施し個人情報の厳重な管理を行ないます。")
    private let policyTextView4 = PolicyTextView(textString: "当方は、お客さまよりお預かりした個人情報を適切に管理し、次のいずれかに該当する場合を除き、個人情報を第三者に開示いたしません。\n• お客さまの同意がある場合\n• 法令に基づき開示することが必要である場合")
    private let policyTextView5 = PolicyTextView(textString: "当方は、保有する個人情報に関して適用される日本の法令、その他規範を遵守するとともに、本ポリシーの内容を適宜見直し、その改善に努めます。")
    private let policyTextView6 = PolicyTextView(textString: "本アプリがユーザーの特定の目的に適合すること、期待する機能・商品的価値・正確性・有用性を有すること、および不具合が生じないことについて、何ら保証するものではありません。\n当方の都合によりアプリの仕様を変更できます。私たちは、本アプリの提供の終了、変更、または利用不能、本アプリの利用によるデータの消失または機械の故障もしくは損傷、その他本アプリに関してユーザーが被った損害につき、賠償する責任を一切負わないものとします。")
    private let policyTextView7 = PolicyTextView(textString: "Twitter: Kento  iOS(@k_m_0504)\n個別の対応はダイレクトメッセージで対応いたします。また、アプリの機能に関しては、App Storeでレビューしていただければ、対応いたします。")
    private let screenSize: CGSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
    }
    
    private func setupLayout() {
        
        self.view.backgroundColor = .white
        
        let policyStackView1 = UIStackView(arrangedSubviews: [policyTitleLabel1, policyTextView1])
        let policyStackView2 = UIStackView(arrangedSubviews: [policyTitleLabel2, policyTextView2])
        let policyStackView3 = UIStackView(arrangedSubviews: [policyTitleLabel3, policyTextView3])
        let policyStackView4 = UIStackView(arrangedSubviews: [policyTitleLabel4, policyTextView4])
        let policyStackView5 = UIStackView(arrangedSubviews: [policyTitleLabel5, policyTextView5])
        let policyStackView6 = UIStackView(arrangedSubviews: [policyTitleLabel6, policyTextView6])
        let policyStackView7 = UIStackView(arrangedSubviews: [policyTitleLabel7, policyTextView7])
        let policyStackViews = [policyStackView1, policyStackView2, policyStackView3, policyStackView4, policyStackView5, policyStackView6, policyStackView7]
        policyStackViews.forEach {
            $0.axis = .vertical
            $0.spacing = 10
        }
        
        let baseStackView = UIStackView(arrangedSubviews: policyStackViews)
        baseStackView.axis = .vertical
        baseStackView.spacing = 20
        baseStackView.distribution = .fillEqually
        
        scrollView.frame = self.view.frame
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 2000)
        view.addSubview(scrollView)
        scrollView.anchor(top: view.topAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        scrollView.addSubview(baseStackView)
        baseStackView.anchor(top: scrollView.topAnchor, bottom: scrollView.bottomAnchor, left: scrollView.leftAnchor, right: scrollView.rightAnchor, topPadding: 25 ,leftPadding: 25, rightPadding: 25)
        policyStackView1.anchor(width: screenSize.width - 50, height: 150)
    }
}
