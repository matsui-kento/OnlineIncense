//
//  WritingFormViewModel.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/14.
//

import Foundation
import RxCocoa
import RxSwift

class WritingFormViewModel {
    // 1
    // Create subjects/observable
    let nameSubject = BehaviorRelay<String?>(value: "")
    let addressSubject = BehaviorRelay<String?>(value: "")
    let numberSubject = BehaviorRelay<String?>(value: "")
    let relationSubject = BehaviorRelay<String?>(value: "")
    let disposeBag = DisposeBag()
    
    // 2
    // Observable - combine few conditions
    var isValidForm: Observable<Bool> {
        // check if name is valid not empty
        return Observable.combineLatest(nameSubject, addressSubject, numberSubject, relationSubject) { name, address, number, relation in
            guard name != nil && address != nil && number != nil && relation != nil else {
                return false
            }
            // Conditions:
            // name not empty
            return !(name!.isEmpty) && !(address!.isEmpty) && !(number!.isEmpty) && !(relation!.isEmpty)
        }
    }
}
