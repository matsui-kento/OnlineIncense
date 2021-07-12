//
//  CreateFormViewModel.swift
//  OnlineIncense
//
//  Created by matsui kento on 2021/07/12.
//


import Foundation
import RxCocoa
import RxSwift

class CreateFormViewModel {
    // 1
    // Create subjects/observable
    let deceasedNameSubject = BehaviorRelay<String?>(value: "")
    let deceasedHiraganaSubject = BehaviorRelay<String?>(value: "")
    let homelessSubject = BehaviorRelay<String?>(value: "")
    let placeSubject = BehaviorRelay<String?>(value: "")
    let addressSubject = BehaviorRelay<String?>(value: "")
    let scheduleSubject = BehaviorRelay<String?>(value: "")
    let disposeBag = DisposeBag()
    let minPasswordCharacters = 6
    
    // 2
    // Observable - combine few conditions
    var isValidForm: Observable<Bool> {
        // check if name is valid not empty
        // valid email
        // password >= N
        return Observable.combineLatest(deceasedNameSubject, deceasedHiraganaSubject, homelessSubject, placeSubject, addressSubject, scheduleSubject) { deceasedName, deceasedHiragana, homeless, place, address, schedule in
            guard deceasedName != nil && deceasedHiragana != nil && homeless != nil && place != nil && address != nil && schedule != nil else {
                return false
            }
            // Conditions:
            // name not empty
            // email is valid
            // password greater or equal to specified
            return !(deceasedName!.isEmpty) && !(deceasedHiragana!.isEmpty) && !(homeless!.isEmpty) && !(place!.isEmpty) && !(address!.isEmpty) && !(schedule!.isEmpty)
        }
    }
}
