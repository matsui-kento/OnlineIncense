//
//  Firebase+Extension.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/11.
//

import Firebase
import FirebaseAuth
import FirebaseStorage
//import FirebaseFirestore

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
        
        let dictionary: [String:Any] = ["name": name, "email": email, "uid" : uid]
        let docRef = Firestore.firestore().collection("Users").document(uid)
        docRef.setData(dictionary) { error in
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
    
    static func setInfoWithoutIncense(deceasedName: String, deceasedHiragana: String, homeless: String, prefecture: String, place: String, address: String, schedule: String, completion: @escaping (Bool) -> ()) {
        
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
                                  "uid": uid]
        
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
            
            infoArray = infoArray?.filter { ($0.deceasedHiragana == name) && ($0.prefecture == prefecture) }
            completion(infoArray ?? [Info]())
            
        }
        
    }
    
}