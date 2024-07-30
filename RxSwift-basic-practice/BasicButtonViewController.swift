//
//  BasicButtonViewController.swift
//  RxSwift-basic-practice
//
//  Created by junehee on 7/30/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class BasicButtonViewController: UIViewController {
    
    private let button = UIButton() // 이벤트를 보내주는 역할 Observable
    private let label = UILabel()   // 이벤트를 받아서 처리하는 역할 Observer
    
    private let textField = UITextField()
    private let secondLabel = UILabel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        // firstExample()
        secondExample()
    }
    
    private func configureView() {
        view.backgroundColor = .white
        view.addSubview(button)
        view.addSubview(label)
        
        view.addSubview(textField)
        view.addSubview(secondLabel)
        
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
        
        label.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(100)
        }
        
        textField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalTo(label.snp.bottom).offset(20)
        }
        
        secondLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalTo(textField.snp.bottom).offset(20)
        }
        
        button.backgroundColor = .systemBlue
        label.backgroundColor = .lightGray
        textField.backgroundColor = .cyan
        secondLabel.backgroundColor = .green
        
        // 시간순에 따라 변화 - Observable Stream (Sequence)
        // button               // UIButton
        //    .rx               // Reactive<UIButton>
        //    .tap              // ControlEvent<Void>
    }
    
    
    private func firstExample() {
        // // Infinite Observable
        // // 1.
        // button.rx.tap
        //     .subscribe { _ in
        //         // 버튼을 클릭했을 때
        //         self.label.text = "버튼을 클릭했어요"
        //         print("next")
        //     } onError: { error in
        //         print("error")
        //     } onCompleted: {
        //         print("completed")
        //     } onDisposed: {
        //         print("disposed")
        //     }
        //     .disposed(by: disposeBag)
        // 
        // // 2. 생략
        // // Tap에서 Error가 발생하는 일, 이벤트가 끝나는 경우도 없기 때문에 해당 코드를 생략
        // button.rx.tap
        //     .subscribe { _ in
        //         // 버튼을 클릭했을 때
        //         self.label.text = "버튼을 클릭했어요"
        //         print("next")
        //     } onDisposed: {
        //         print("disposed")
        //     }
        //     .disposed(by: disposeBag)
        // 
        // // 3. leak
        // button.rx.tap
        //     .subscribe { [weak self] _ in
        //         // 버튼을 클릭했을 때
        //         self?.label.text = "버튼을 클릭했어요"
        //         print("next")
        //     } onDisposed: {
        //         print("disposed")
        //     }
        //     .disposed(by: disposeBag)
        // 
        // // 4.
        // button.rx.tap
        //     .withUnretained(self)   // weak self
        //     .subscribe { _ in
        //         // 버튼을 클릭했을 때
        //         self.label.text = "버튼을 클릭했어요"
        //         print("next")
        //     } onDisposed: {
        //         print("disposed")
        //     }
        //     .disposed(by: disposeBag)
        // 
        // 
        // // 5.
        // // .withUnretained(self)를 반복적으로 작성하는 걸 줄이기 위해 .subscribe(with: ~
        // // subscribe: 스레드가 보장이 되지 않음. 즉 background에서도 동작이 계속될 수 있다.
        // // -> 네트워크 통신이 섞이거나 스레드가 섞이면 보라색 오류가 발생할 수 있음
        // // -> DispatchQueue.main 으로 감싸주어야 함
        // button.rx.tap
        //     .subscribe(with: self, onNext: { owner, _ in
        //         DispatchQueue.main.async {
        //             owner.label.text = "버튼을 클릭했어요"
        //         }
        //     }, onDisposed: { _ in
        //         print("disposed")
        //     })
        //     .disposed(by: disposeBag)
        // 
        // 
        // 
        // // 6번부터는 UIKit으로 인해 달라지는 것들
        // // case 6
        // 
        // 
        // 
        // 
        // 
        // 
        // // 7.
        // button.rx.tap
        //     .observe(on: MainScheduler.instance)    // -> 이후에 진행하는 코드는 Main 스레드로 할게! 라는 뜻
        //     .subscribe(with: self, onNext: { owner, _ in
        //         owner.label.text = "버튼을 클릭했어요"
        //     }, onDisposed: { _ in
        //         print("disposed")
        //     })
        //     .disposed(by: disposeBag)
        // 
        // 
        // // 8.
        // // 메인 스레드로 동작시켜주는 친구는 왜 래핑을 안 해주지? + 탭은 에러가 발생하지 않으니까 애초에 error를 안 받는 친구는 없나?
        // // -> bind
        // button.rx.tap
        //     .bind(with: self, onNext: { owner, _ in
        //         owner.label.text = "버튼을 클릭했어요"
        //     })
        //     .disposed(by: disposeBag)
        // 
        
        // ========= 여기까지만 이해해도 충분!
        
        
        // 9.
        // bind to - 다이렉트로 특정 뷰에 넣어버리기
        button.rx.tap
            .map { "버튼을 클릭했어요" }    // Observable<String>
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
        
        
        // Quiz
        // label.rx.text.subscribe ... 왜 안될까?! 이유를 생각해보기.
    }
    
    private func secondExample() {
        button.rx.tap
            .map { "버튼을 다시! 클릭했어요" }
            .bind(to: secondLabel.rx.text, textField.rx.text)
            .disposed(by: disposeBag)
    }
    
    
}
