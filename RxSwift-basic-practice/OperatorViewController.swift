//
//  OperatorViewController.swift
//  RxSwift-basic-practice
//
//  Created by junehee on 7/30/24.
//

import UIKit
import RxSwift
import RxCocoa

/**
 1) disposed(by: )
 disposeBag 프로퍼티는 OperatorViewController가 deinit되지않는 한 계속 살아있고 메모리에 존재한다.
 OperatorViewController가 deinit 된다는 것은 가지고 있는 프로퍼티들이 모두 잘 정리되었을 때 → disposeBag이 메모리에서 사라질 수 있다.
 만약 OperatorViewController == rootViewController 일 때, root는 deinit 되지 않고 계속 메모리에 존재하게 된다. → disposeBag이 메모리에 계속 존재  → disposeBag과 관련된 코드도 모두 살아있음
 
 
 2) dispose()
 */

final class OperatorViewController: UIViewController {
    
    private var disposeBag = DisposeBag()
    
    let list = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    let list2 = [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]
    
    deinit {
        print("OperatorViewController Deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // testJustObservable()
        // testOfObservable()
        // testFromObservable()
        testIntervalObservable()
        testIntervalObservable2()
    }
    
    private func testJustObservable() {
        
        Observable                  // 이벤트를 전달할게
            .just(list)             // just 방식으로 전달할게 (데이터를 통째로 전달)
            .subscribe { value in   // 이벤트가 오는지 관찰할게
                print("Next -", value)
            } onError: { error in
                print("Next Error -", error)
            } onCompleted: {
                print("Next Completed")
            } onDisposed: {
                print("Next Disposed")
            }
            .disposed(by: disposeBag)
        
        /**
         
             Next - [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
             Next Completed
             Next Disposed
         
         */
        
    }
    
    private func testOfObservable() {
        
        Observable                  // 이벤트를 전달할게
            .of(list, list2)        // of 방식으로 전달할게 (데이터를 통째로 전달 - 2개 이상 가능!)
            .subscribe { value in   // 이벤트가 오는지 관찰할게
                print("Of -", value)
            } onError: { error in
                print("Of Error -", error)
            } onCompleted: {
                print("Of Completed")
            } onDisposed: {
                print("Of Disposed")
            }
            .disposed(by: disposeBag)
        
        /**
         
             Of - [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
             Of - [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]
             Of Completed
             Of Disposed
             
         */
        
    }
    
    private func testFromObservable() {
        
        Observable                  // 이벤트를 전달할게
            .from(list)             // from 방식으로 전달할게 (데이터 내부에 있는 요소들을 하나씩 전달)
            .subscribe { value in   // 이벤트가 오는지 관찰할게
                print("From -", value)
            } onError: { error in
                print("From Error -", error)
            } onCompleted: {
                print("From Completed")
            } onDisposed: {
                print("From Disposed")
            }
            .disposed(by: disposeBag)
        
        /**
         
                 From - 1
                 From - 2
                 From - 3
                 From - 4
                 From - 5
                 From - 6
                 From - 7
                 From - 8
                 From - 9
                 From - 10
                 From Completed
                 From Disposed
                 
         */
        
    }
    
    private func testIntervalObservable() {
        // infinite
        Observable<Int>          // 이벤트를 전달할게
            .interval(.seconds(1), scheduler: MainScheduler.instance)  // 1초마다, 메인 스케줄러에
            .subscribe { value in   // 이벤트가 오는지 관찰할게
                print("Interval -", value)
            } onError: { error in
                print("Interval Error -", error)
            } onCompleted: {
                print("Interval Completed")     // infinite는 completed 되지 않는다.
            } onDisposed: {
                print("Interval Disposed")      // completed 되지 않으면 disposed 할 수 없다. (다른 화면이 떠있더라도 이 이벤트는 사라지지 않는다 -> 메모리에 남아있다 -> 메모리 누수 발생)
            }
            .disposed(by: disposeBag)           // ViewController가 종료될 때 처분해줘
            // .dispose()                       // 지금 바로 즉시! 처분해줘
        
        /**
         .disposed(by: disposeBag)
         
             Interval - 0
             Interval - 1
             Interval - 2
             Interval - 3
             Interval - 4
             Interval - 5
             Interval - 6
             Interval - 7
             Interval - 8
             Interval - 9
             Interval - 10
             Interval - 11
             Interval - 12
             Interval - 13
                .
                .
                .
                 
         */
        
        /**
         .dispose()
        
                Interval Disposed
         
         */

        
        // infinite 코드는 계속해서 실행된다. 언젠간 멈춰주어야 하는데, 어떻게?
        // 여러 방법이 있다 (take 메서드 사용, 타이머 사용...)
        
        // Observable - Observer 코드를 분리
        let incrementValue = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        
        let observer = incrementValue
            .subscribe { value in
                print("Interval -", value)
            } onError: { error in
                print("Interval Error -", error)
            } onCompleted: {
                print("Interval Completed")
            } onDisposed: {
                print("Interval Disposed")
            }
        
        // 5초 뒤에 observer를 종료해달라고 요청 (원하는 시점에 종료 핸들링)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            observer.dispose()
        }
        
        /**
         
             Interval - 0
             Interval - 1
             Interval - 2
             Interval - 3
             Interval - 4
             Interval Disposed
         
         */
        
        
    }
    
    private func testIntervalObservable2() {
        // 하지만 구독하고 있는 객체가 여러 개라면? 개별적으로 핸들링 할 수 있을까?
        // 관리는 가능하겠지만... 휴먼 에러 확률이 높아진다. 힘들어진다.
        // -> disposeBag 프로퍼티에 몰아준다.
        
        // infinite
        let incrementValue = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        
        incrementValue
            .subscribe { value in
                print("Interval 2 -", value)
            } onError: { error in
                print("Interval Error 2 -", error)
            } onCompleted: {
                print("Interval Completed 2")
            } onDisposed: {
                print("Interval Disposed 2")
            }
            .disposed(by: disposeBag)
        
        // DisposeBag의 인스턴스를 초기화 하는 과정을 통해 한 번에 핸들링
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            self.disposeBag = DisposeBag()
        }
        
        
        // 만약 특정한 것들만 종료 시점을 따로 핸들링 하고 싶다면 disposeBag을 따로 관리할 수 있다.
        // disposeBag이 무조건 하나여야 한다는 법은 없음!
    }
    
}
