//
//  LoginViewModel.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/12.
//

import Foundation
import RxCocoa
import RxSwift

class LoginViewModel {
    // 1
    // Create subjects/observable
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
        return Observable.combineLatest(emailSubject, passwordSubject) { email, password in
            guard email != nil && password != nil else {
                return false
            }
            // Conditions:
            // email is valid
            // password greater or equal to specified
            return email!.validateEmail() && password!.count >= self.minPasswordCharacters
        }
    }
}

