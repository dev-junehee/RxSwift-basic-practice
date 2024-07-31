//
//  UserViewController.swift
//  RxSwift-basic-practice
//
//  Created by junehee on 7/31/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class UserViewController: UIViewController {
    
    private let nicknameTextField = UITextField()
    private let checkButton = UIButton()
    
    // private let sampleNickname = "평냉조아"
    // private let sampleNickname = Observable.just("평냉조아")    // Observable : 이벤트를 전달하는 역할!
    
    private var sampleNickname = BehaviorSubject(value: "평냉조아")     // Subject: 이벤트를 전달/처리 둘 다 해주는 역할!
    private var behavior = BehaviorSubject(value: 1000)
    
    private var publish = PublishSubject<Int>()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        // testBehaviorSubject()
        testPublishSubject()
        
        sampleNickname
            .bind(with: self) { owner, value in
                owner.nicknameTextField.text = value
            }
            .disposed(by: disposeBag)
    
        /// 아래처럼 작성해도 똑같음!
        // sampleNickname
        //     .bind(to: nicknameTextField.rx.text)
        //     .disposed(by: disposeBag)
        
        checkButton.rx.tap
            .bind(with: self) { owner, _ in
                // sampleNickname = "딤섬조아"
                // sampleNickname은 이벤트를 전달하는 역할이지, 받아서 처리하는 역할이 아니다!
                // -> 이벤트나 데이터를 받을 수 있는 상태로 변경이 필요
                // -> Observable과 Observer의 역할을 동시에 수행하는 친구가 필요해짐
                // -> Subject 등장
                
                // = 연산자로 값을 바꾸지 않는다.
                // 뭐든 이벤트 전달로 처리! (next, completed, error)
                owner.sampleNickname.onNext("딤섬조아 \(Int.random(in: 1...100))")  // 버튼을 클릭할 때마다 sampleNickname의 데이터가 바뀜!
            }
            .disposed(by: disposeBag)
    }
    
    private func configureView() {
        view.backgroundColor = .white
        view.addSubview(nicknameTextField)
        view.addSubview(checkButton)
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(50)
        }
        
        checkButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(50)
        }
        
        nicknameTextField.placeholder = "닉네임을 입력해 주세요~~~~"
        nicknameTextField.backgroundColor = .systemGroupedBackground
        
        checkButton.setTitle("확인", for: .normal)
        checkButton.backgroundColor = .systemPink
    }
    
    private func testBehaviorSubject() {
        
        // behavior.onNext(1)  // observer 역할
        // behavior.onNext(2)
        // behavior.onNext(3)
        
        behavior   // observable 역할
            .subscribe { value in   //
                print("Behavior Next -", value)
            } onError: { error in
                print("Behavior error -", error)
            } onCompleted: {
                print("Behavior Completed")
            } onDisposed: {
                print("Behavior Disposed")
            }
            .disposed(by: disposeBag)
        
        behavior.onNext(4)  // observer 역할
        behavior.onNext(5)
        behavior.onNext(6)
        
        /**
         
             Behavior Next - 3
             Behavior Next - 4
             Behavior Next - 5
             Behavior Next - 6
         
         왜 3, 4, 5,6 만 프린트 될까?
         behavior에 subscribe 되기 전의 코드는 구독하고 있지 않았기 때문에 프린트 되지 않는다.
         
         3이 프린트되는 이유는 behavior가 가지고 있는 초기값이기 때문.
         만약 onNext(1) ~ (3)이 없다면, 기존에 가지고 있던 값 1000이 프린트 된다.
         
             Behavior Next - 1000
             Behavior Next - 4
             Behavior Next - 5
             Behavior Next - 6
         
         */
        
    }
    
    private func testPublishSubject() {
        
        publish.onNext(1)  // observer 역할
        publish.onNext(2)
        publish.onNext(3)
        
        publish   // observable 역할
            .subscribe { value in   //
                print("Publish Next -", value)
            } onError: { error in
                print("Publish error -", error)
            } onCompleted: {
                print("Publish Completed")
            } onDisposed: {
                print("Publish Disposed")
            }
            .disposed(by: disposeBag)
        
        publish.onNext(4)  // observer 역할
        publish.onNext(5)
        publish.onNext(6)
        
        /**
                     
             Publish Next - 4
             Publish Next - 5
             Publish Next - 6
                 
         */
        
        
        publish.onNext(4)
        publish.onCompleted()  // -> Disposed로 이어짐!
        publish.onNext(5)
        publish.onNext(6)
        
        /**
                     
             Publish Next - 4
             Publish Completed
             Publish Disposed
                 
         */
        
    }
    
}
