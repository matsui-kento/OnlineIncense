//
//  AddBankAccountViewModel.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/21.
//

import Foundation
import RxCocoa
import RxSwift

class AddBankAccountViewModel {
    // 1
    // Create subjects/observable
    let bankAccountNameSubject = BehaviorRelay<String?>(value: "")
    let bankNumberSubject = BehaviorRelay<String?>(value: "")
    let bankNameSubject = BehaviorRelay<String?>(value: "")
    let branchCodeSubject = BehaviorRelay<String?>(value: "")
    let kindBankAccountSubject = BehaviorRelay<String?>(value: "")
    let typeSubject = BehaviorRelay<String?>(value: "")
    let bankAccountNumberSubject = BehaviorRelay<String?>(value: "")
    let disposeBag = DisposeBag()
    
    // 2
    // Observable - combine few conditions
    var isValidForm: Observable<Bool> {
        // check if name is valid not empty
        return Observable.combineLatest(bankAccountNameSubject, bankNumberSubject, bankNameSubject, branchCodeSubject, kindBankAccountSubject, typeSubject, bankAccountNumberSubject) { bankAccountName, bankNumber, bankName, branchCode, kindBankAccount, type, bankAccountNumber in
            guard bankAccountName != nil && bankNumber != nil && bankName != nil && branchCode != nil && kindBankAccount != nil && type != nil && bankAccountNumber != nil  else {
                return false
            }
            // Conditions:
            // name not empty
            return !(bankAccountName!.isEmpty) && !(bankNumber!.isEmpty) && !(bankName!.isEmpty) && !(branchCode!.isEmpty) && !(kindBankAccount!.isEmpty) && !(type!.isEmpty) && !(bankAccountNumber!.isEmpty)
        }
    }
}

