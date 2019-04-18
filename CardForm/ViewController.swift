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
       
        self.cardNumberView.inputTextField.rx.controlEvent([.editingDidEnd]).asObservable()
            .subscribe(onNext: { [weak self] (_) in
                self?.cardNameView.inputTextField.becomeFirstResponder()
            }).disposed(by: self.disposeBag)
        
12    }
}

