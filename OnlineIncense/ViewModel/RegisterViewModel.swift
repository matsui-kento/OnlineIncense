//
//  AuthViewModel.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/12.
//

import Foundation
import RxCocoa
import RxSwift

class RegisterViewModel {
    // 1
    // Create subjects/observable
    let nameSubject = BehaviorRelay<String?>(value: "")
    let emailSubject = BehaviorRelay<String?>(value: "")
    let passwordSubject = BehaviorRelay<String?>(value: "")
    let disposeBag = DisposeBag()
    let minPasswordCharacters = 6
    
    // 2
    // Observable - combine few conditions
    var isValidForm: Observable<Bool> {
        // check if name is valid not empty
        // valid email
        // password >= N
        return Observable.combineLatest(nameSubject, emailSubject, passwordSubject) { name, email, password in
            guard name != nil && email != nil && password != nil else {
                return false
            }
            // Conditions:
            // name not empty
            // email is valid
            // password greater or equal to specified
            return !(name!.isEmpty) && email!.validateEmail() && password!.count >= self.minPasswordCharacters
        }
    }
}
