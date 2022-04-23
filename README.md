# オンライン香典(OnlineIncense)
芳名録の記入、香典の受け渡しができるアプリです。

言語はSwift、サーバーはFirebase、決済サービスは[Omise](https://www.omise.co/)を利用して開発しました。

しかし、決済サービス(Omise)から本番で利用するなら法人としか契約できないと言われ、合同会社を設立しました。

その後、法律的な問題が見つかり、リリースを断念しました。

## 主な機能

### 芳名録を作成する

https://user-images.githubusercontent.com/69304437/138033981-85dd465b-cb1b-4ff9-b075-909caeb8217a.mp4

---

### 検索する → 香典を贈る

https://user-images.githubusercontent.com/69304437/138034002-8dd1d920-c8ff-4b0f-83cb-9a5f97d4e728.mp4

---

### 参列者を確認する → 香典ありと香典なしで絞り込む

https://user-images.githubusercontent.com/69304437/138034019-a822e43b-61ea-40c9-912b-c16206564e8b.mp4

---

## 利用しているライブラリ

### CococaPods
- [Firebase/Auth](https://github.com/firebase/firebase-ios-sdk)

- [Firebase/Firestore](https://github.com/firebase/firebase-ios-sdk)

- [Firebase/Storage](https://github.com/firebase/firebase-ios-sdk)

- [PKHUD](https://github.com/pkluz/PKHUD)

- [RxSwift](https://github.com/ReactiveX/RxSwift)

- [RxCocoa](https://github.com/ReactiveX/RxSwift)

### Swift Package Manager

- [Omise SDK](https://github.com/omise/omise-ios.git)

- [CurlDSL](https://github.com/zonble/CurlDSL)
