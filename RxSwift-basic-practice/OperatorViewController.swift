//
//  OperatorViewController.swift
//  RxSwift-basic-practice
//
//  Created by junehee on 7/30/24.
//

import UIKit
import RxSwift
import RxCocoa

final class OperatorViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // just, from, of, interval ...
        // zip, combinelatest
        Observable
            .repeatElement("JuneHee")  // 문자열이 계속 반복됨 -> 잘못 사용하면 Xcode, Mac 꺼질 수 있음
            .take(10)  // 이벤트를 10개만 보내줘! (제약조건)
            .subscribe { value in
                print("next:", value)   // -> next는 여러 번 실행될 수 있다.
            } onError: { error in
                print("error")
            } onCompleted: {
                print("completed") // -> disposed 연결
            } onDisposed: {
                print("disposed")
            }
            .disposed(by: disposeBag)
        
        // 어떤 메서드던 complete 또는 error를 만나면 disposed 된다 
        // = deinit
        

    }
    
}
