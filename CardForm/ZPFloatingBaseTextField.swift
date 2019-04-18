//
//  ZPFloatingBaseTextField.swift
//  CardForm
//
//  Created by nhatnt on 4/18/19.
//  Copyright © 2019 nhatnt. All rights reserved.
//

import UIKit
import RxSwift

enum TextFieldStatus {
    case valid
    case invalid
}
struct TextFieldNotification {
    var message: String?
    var status: TextFieldStatus
}

class ZPFloatingBaseTextField: UIView, UITextFieldDelegate {
    //MARK: Properties
    @IBInspectable var title : String = "" {
        didSet {
            setupSubviews()
        }
    }
    var titleAlignment : NSTextAlignment {
        get {
            return .left
        }
    }
    @IBInspectable var titleColor : UIColor = UIColor.white {
        didSet {
            setupSubviews()
        }
    }

    @IBInspectable var placeholderColor : UIColor = UIColor.lightGray {
        didSet {
            setupSubviews()
        }
    }
    @IBInspectable var placeholderText : String = "" {
        didSet {
            setupSubviews()
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        self.addSubview(label)
        label.snp.makeConstraints {
            $0.leading.width.top.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.4)
        }
        return label
    }()
    
    let disposeBag = DisposeBag()
    let notification = Variable<TextFieldNotification>(.init(message: "", status: .valid))
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        self.addSubview(textField)
        textField.font = UIFont.systemFont(ofSize: fontSizeScaled(18.0))
        textField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(valueScaled(-4))
            $0.height.equalToSuperview().multipliedBy(0.5)
        }
        return textField
    }()
    
    //MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupSubviews()
    }
    
    //MARK: Private Methods
    
    func setupSubviews() {
        self.titleLabel.text = self.title
        self.titleLabel.textColor = self.titleColor
        self.titleLabel.font = UIFont.systemFont(ofSize: fontSizeScaled(10.0))
        
        self.inputTextField.text = self.placeholderText
        self.inputTextField.textColor = self.placeholderColor
        self.inputTextField.delegate = self
        
        let line = ZPLineView()
        line.backgroundColor = self.titleColor
        self.addSubview(line)
        line.alignToBottom()
        
    }
    
    func setupNotification() {
        notification.asObservable().subscribe(onNext: { (noti) in
            if noti.status == .invalid {
                self.titleLabel.text = noti.message
                self.titleLabel.snp.remakeConstraints {
                    if let widthTitleLabel = noti.message?.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: fontSizeScaled(12.0))]).width {
                        $0.width.equalTo(widthTitleLabel)
                    } else {
                        $0.width.equalToSuperview()
                    }
                    $0.leading.top.equalToSuperview()
                    $0.height.equalToSuperview().multipliedBy(0.4)
                }
                self.titleLabel.textColor = .red
                self.titleLabel.backgroundColor = .white
                self.titleLabel.textAlignment = .center
                return
            }
            
            self.titleLabel.snp.remakeConstraints {
                $0.leading.width.top.equalToSuperview()
                $0.height.equalToSuperview().multipliedBy(0.4)
            }
            self.titleLabel.text = self.title
            self.titleLabel.textColor = self.titleColor
            self.titleLabel.textAlignment = self.titleAlignment
            self.titleLabel.backgroundColor = .clear
        }).disposed(by: self.disposeBag)
    }
}
