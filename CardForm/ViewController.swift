//
//  ViewController.swift
//  CardForm
//
//  Created by nhatnt on 4/11/19.
//  Copyright © 2019 nhatnt. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    @IBOutlet weak var cardNumberView: ZPFloatingCardNumberField!
    @IBOutlet weak var cardNameView: ZPFloatingTextField!
    @IBOutlet weak var cardExpireDateView: ZPFloatingDateTextField!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.cardExpireDateView.inputTextField.rx.controlEvent([.editingDidEnd]).asObservable()
            .subscribe(onNext: { [weak self] (_) in
                self?.cardExpireDateView.notification.value = .init(message: nil, status: .valid)
            }).disposed(by: self.disposeBag)
        
        self.cardExpireDateView.inputTextField.rx.controlEvent([.editingDidBegin]).asObservable()
            .subscribe(onNext: { [weak self] (_) in
                self?.cardExpireDateView.notification.value = .init(message: "Thẻ không hợp lệ", status: .invalid)
            }).disposed(by: self.disposeBag)
      }
}

