//
//  Firebase+Extension.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/11.
//

import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

extension Auth {
    
    static func createUserWithFirestore(name: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if let error = error {
                print("新規ユーザーの登録に失敗しました。")
                print(error.localizedDescription)
                completion(false)
                return
            }
            
            guard let uid = user?.user.uid else { return }
            Firestore.setUser(name: name, email: email, uid: uid) { success in
                completion(success)
            }
        }
    }
    
    static func loginUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if let error = error {
                print("ログインに失敗しました")
                print(error.localizedDescription)
                completion(false)
                return
            }
            
            print("ログインに成功しました")
            completion(true)
        }
    }
    
}

extension Firestore {
    
    static func setUser(name: String, email: String, uid: String, completion: @escaping (Bool) -> ()) {
        
        let data: [String:Any] = ["name": name,
                                        "email": email,
                                        "uid" : uid]
        let docRef = Firestore.firestore().collection("Users").document(uid)
        docRef.setData(data) { error in
            if let error = error {
                print("新規ユーザー情報の保存に失敗しました。")
                print(error.localizedDescription)
                completion(false)
                return
            }
            print("新規ユーザー情報の保存に成功しました。")
            completion(true)
        }
    }
    
    static func setInfo(deceasedName: String, deceasedHiragana: String, homeless: String, prefecture: String, place: String, address: String, schedule: String, incense: Bool, other: String, completion: @escaping (Bool) -> ()) {
        
        print("extensionまで来た")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let docRef = Firestore.firestore().collection("Infos").document()
        let data: [String:Any] = ["deceasedName": deceasedName,
                                  "deceasedHiragana": deceasedHiragana,
                                  "homeless": homeless,
                                  "prefecture": prefecture,
                                  "place": place,
                                  "address": address,
                                  "schedule": schedule,
                                  "uid": uid,
                                  "documentID": docRef.documentID,
                                  "incense": incense,
                                  "other": other,
                                  "search": true]
        
        docRef.setData(data) { error in
            if error != nil {
                print("Firestoreへの情報の保存が失敗しました。")
                print(error.debugDescription)
                completion(false)
                return
            }
            print("Firestoreへの情報の保存が成功しました。")
            completion(true)
        }
    }
    
    static func setParticipant(name: String, hurigana: String, address: String, number: String, company: String, relation: String, documentID: String, completion: @escaping (String) -> ()) {
        
        let docRef = Firestore.firestore().collection("Infos").document(documentID).collection("Participants").document()
        let documentID = docRef.documentID
        let data: [String: Any] = ["name": name,
                                   "hurigana": hurigana,
                                   "address": address,
                                   "number": number,
                                   "company": company,
                                   "relation": relation]
        docRef.setData(data) { error in
            if error != nil {
                print(error.debugDescription)
                completion("")
                return
            }
            print("Firestoreへの保存が成功しました。")
            completion(documentID)
        }
    }
    
    static func setBankAccount(name: String, bankAccountName: String, bankNumber: String, bankName: String, branchCode: String, kindBankAccount: String, type: String, bankAccountNumber: String, uid: String, completion: @escaping (Bool) -> ()) {
        let docRef = Firestore.firestore().collection("Users").document(uid).collection("BankAccounts").document()
        let documentID = docRef.documentID
        let data: [String: Any] = ["bankAccountName": bankAccountName,
                                   "bankNumber": bankNumber,
                                   "bankName": bankName,
                                   "branchCode": branchCode,
                                   "kindBankAccount": kindBankAccount,
                                   "type": type,
                                   "bankAccountNumber": bankAccountNumber,
                                   "uid": uid,
                                   "documentID": documentID]
        docRef.setData(data) { error in
            if error != nil {
                print(error.debugDescription)
                completion(false)
                return
            }
            
            print("銀行口座の保存に成功しました。")
            completion(true)
        }
    }
    
    static func setTransfer(incensePrice: String, transferPrice: String, bankAccountName: String, bankName: String, branchCode: String, bankAccountNumber: String, uid: String, infoID: String, completion: @escaping (Bool) -> ()) {
        let docRef = Firestore.firestore().collection("NotTransfer").document()
        let documentID = docRef.documentID
        let data = ["incensePrice": incensePrice,
                    "transferPrice": transferPrice,
                    "bankAccountName": bankAccountName,
                    "bankName": bankName,
                    "branchCode": branchCode,
                    "bankAccountNumber": bankAccountNumber,
                    "uid": uid,
                    "documentID": documentID]
        docRef.setData(data) { error in
            if error != nil {
                print(error.debugDescription)
                completion(false)
                return
            }
            print("振込申請が完了しました。")
            Firestore.updateInfoForSearchAndTranfer(infoID: infoID) { success in
                completion(success)
            }
        }
    }
    
    static func updateIncenseForParticipant(incense: String, infoID: String, participantID: String, completion: @escaping (Bool) -> ()) {
        
        let docRef = Firestore.firestore().collection("Infos").document(infoID).collection("Participants").document(participantID)
        var incenseString: String
        if incense == "0" {
            incenseString = "香典なし"
        } else {
            incenseString = "\(incense)円"
        }
        docRef.setData(["incense": incenseString], merge: true) { error in
            if error != nil {
                print(error.debugDescription)
                completion(false)
                return
            }
            
            print("香典の保存に成功しました。")
            completion(true)
        }
    }
    
    static func updateIncenseForInfo(infoID: String, newIncensePrice: Int) {
        
        let docRef = Firestore.firestore().collection("Infos").document(infoID)
        docRef.getDocument { snapshot, error in
            if error != nil {
                print(error.debugDescription)
                return
            }
            
            let data = snapshot?.data()
            let info = Info(dic: data!)
            var incensePrice = info.incensePrice
            incensePrice += newIncensePrice
            
            docRef.setData(["incensePrice": incensePrice], merge: true) { error in
                if error != nil {
                    print(error.debugDescription)
                    return
                }
            }
        }
    }
    
    static func updateInfoForSearchAndTranfer(infoID: String, completion: @escaping (Bool) -> ()) {
        
        let docRef = Firestore.firestore().collection("Infos").document(infoID)
        docRef.setData(["search": false, "transfer": true], merge: true) { error in
            if error != nil {
                print(error.debugDescription)
                completion(false)
                return
            }
            print("Infoが検索に引っ掛からないようにしました。")
            completion(true)
        }
    }
    
    static func updateInfoForEdit(deceasedName: String, deceasedHiragana: String, homeless: String, prefecture: String, place: String, address: String, schedule: String, other: String, infoID: String, completion: @escaping (Bool) -> ()) {
        
        let docRef = Firestore.firestore().collection("Infos").document(infoID)
        let data: [String:Any] = ["deceasedName": deceasedName,
                                  "deceasedHiragana": deceasedHiragana,
                                  "homeless": homeless,
                                  "prefecture": prefecture,
                                  "place": place,
                                  "address": address,
                                  "schedule": schedule,
                                  "other": other]

        docRef.setData(data, merge: true) { error in
            if error != nil {
                print("Firestoreへの情報更新が失敗しました。")
                print(error.debugDescription)
                completion(false)
                return
            }
            print("Firestoreの情報更新が成功しました。")
            completion(true)
        }
        
    }
    
    static func fetchInfoForSeach(name: String, prefecture: String, completion: @escaping ([Info]?) -> ()) {
        
        let docRef = Firestore.firestore().collection("Infos")
        docRef.getDocuments { snapshot, error in
            if error != nil {
                print(error.debugDescription)
                completion(nil)
                return
            }
            
            var infoArray = snapshot?.documents.map({ snapshot -> Info in
                let data = snapshot.data()
                let info = Info(dic: data)
                return info
            })
            
            infoArray = infoArray?.filter { ($0.deceasedHiragana == name) && ($0.prefecture == prefecture) && ($0.search == true) }
            completion(infoArray ?? [Info]())
        }
    }
    
    static func fetchInfoForMyPage(uid: String, completion: @escaping ([Info]?) -> ()) {
        
        let docRef = Firestore.firestore().collection("Infos")
        docRef.getDocuments { snapshot, error in
            if error != nil {
                print(error.debugDescription)
                completion(nil)
                return
            }
            
            var infoArray = snapshot?.documents.map({ snapshot -> Info in
                let data = snapshot.data()
                let info = Info(dic: data)
                return info
            })
            
            infoArray = infoArray?.filter { ($0.uid == uid) }
            completion(infoArray ?? [Info]())
        }
    }
    
    static func fetchInfoAfterUpdate(infoID: String, completion: @escaping (Info?) -> ()) {
        
        let docRef = Firestore.firestore().collection("Infos").document(infoID)
        docRef.getDocument { snapshot, error in
            if error != nil {
                print(error.debugDescription)
                completion(nil)
                return
            }
            
            let data = snapshot?.data()
            let info = Info(dic: data!)
            completion(info)
        }
        
    }
    
    static func fetchUser(uid: String, completion: @escaping (User?) -> ()) {
        
        let docRef = Firestore.firestore().collection("Users").document(uid)
        docRef.getDocument { snapshot, error in
            if error != nil {
                print(error.debugDescription)
                completion(nil)
                return
            }
            
            let data = snapshot?.data()
            let user = User(dic: data!)
            completion(user)
        }
    }
    
    static func fetchParticipant(documentID: String, completion: @escaping ([Participant]?) -> ()) {
        
        let docRef = Firestore.firestore().collection("Infos").document(documentID).collection("Participants")
        docRef.getDocuments { snapshot, error in
            if error != nil {
                print(error.debugDescription)
                completion(nil)
                return
            }
            
            let participantArray = snapshot?.documents.map({ snapshot -> Participant in
                let data = snapshot.data()
                let participant = Participant(dic: data)
                return participant
            })
            
            completion(participantArray)
        }
    }
    
    static func fetchBankAccount(uid: String, completion: @escaping ([BankAccount]?) -> ()) {
        
        let docRef = Firestore.firestore().collection("Users").document(uid).collection("BankAccounts")
        docRef.getDocuments { snapshot, error in
            if error != nil {
                print(error.debugDescription)
                completion(nil)
                return
            }
            
            let bankAccountArray = snapshot?.documents.map({ snapshot -> BankAccount in
                let data = snapshot.data()
                let bankAccount = BankAccount(dic: data)
                return bankAccount
            })
            
            completion(bankAccountArray)
        }
    }
    
    static func deleteInfo(infoID: String, completion: @escaping (Bool) -> ()) {
        
        let docRef = Firestore.firestore().collection("Infos").document(infoID)
        docRef.delete { error in
            if error != nil {
                print(error.debugDescription)
                completion(false)
                return
            }
            print("infoの削除に成功しました。")
            completion(true)
        }
    }
}
