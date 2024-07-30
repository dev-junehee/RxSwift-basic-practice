//
//  ViewController.swift
//  RxSwift-basic-practice
//
//  Created by junehee on 7/30/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ViewController: UIViewController {

    let tableView = UITableView()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.backgroundColor = .lightGray
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
            
        // Observable: 이벤트를 전달. 일 벌리는 역할.
        let items = Observable.just([
            "First Item",
            "Second Item",
            "Third Item"
        ])
    
        // Observer: 테이블뷰에 데이터를 보여주는 형태로 일을 처리하고 있음.
        // 그나마 비유하자면 Closure 구문이 Observer...
        // bind == subscribe 구독!
        // Dispose: 구독 취소
        // items
        // .bind(to: tableView.rx.items) { (tableView, row, element) in
        //     let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        //     cell.textLabel?.text = "\(element) @ row \(row)"
        //     return cell
        // }
        // .disposed(by: disposeBag)
        
        
        // 인덱스 얻기
        // tableView.rx.itemSelected
        //     .bind { value in
        //         print(value, "가 선택되었어요.")
        //     }
        //     .disposed(by: disposeBag)
        
        
        // 데이터 얻기
        // tableView.rx.modelSelected(String.self)
        //     .bind { value in
        //         print(value, "가 선택되었어요.")
        //    }
        //    .disposed(by: disposeBag)
        
        // 인덱스와 데이터를 한 번에 처리할 순 없나?
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(String.self))
            .bind { value in
                print(value.0, value.1)
            }
            .disposed(by: disposeBag)
        
    }
    
    func testJust() {
        Observable.just([1, 2, 3]) // Finite Observable Sequence 유한한 시퀀스
            .subscribe { value in
                print("next: ", value)
            } onError: { error in
                print("error")
            } onCompleted: {
                print("complete")
            } onDisposed: { // 이벤트는 아님!
                print("dispose")
            }
            .disposed(by: disposeBag)
    }
    
    func testFrom() {
        Observable.from ([1, 2, 3]) // Finite Observable Sequence 유한한 시퀀스
            .subscribe { value in
                print("next: ", value)
            } onError: { error in
                print("error")
            } onCompleted: {
                print("complete")
            } onDisposed: { // 이벤트는 아님!
                print("dispose")
            }
            .disposed(by: disposeBag)
    }

    func testInterval() {
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance) // Infinite Observable Sequence 무한한 시퀀스
            .subscribe { value in
                print("next: ", value)
            } onError: { error in
                print("error")
            } onCompleted: {
                print("complete")
            } onDisposed: { // 이벤트는 아님!
                print("dispose")
            }
            .disposed(by: disposeBag)
    }


}

