//
//  ZPFloatingTextField.swift
//  CardForm
//
//  Created by nhatnt on 4/10/19.
//  Copyright © 2019 nhatnt. All rights reserved.
//

import UIKit
import SnapKit

enum ZPFloatingTextFieldType {
    case normal
    case cardNumber
    case date
}

@IBDesignable class ZPFloatingTextField: UIView {
    
    //MARK: Properties
    @IBInspectable var titleColor : UIColor = UIColor.white {
        didSet {
            setupSubviews()
        }
    }
    @IBInspectable var title : String = "" {
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
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview()
        }
        return label
    }()
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        self.addSubview(textField)
        textField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-4)
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

    // MARK: TextField actions
    
    
    //MARK: Private Methods
    
    private func setupSubviews() {
        self.titleLabel.text = self.title
        self.titleLabel.textColor = self.titleColor
        
        self.inputTextField.text = self.placeholderText
        self.inputTextField.textColor = self.placeholderColor
        self.inputTextField.delegate = self
    }
    
}

extension ZPFloatingTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.textColor == UIColor.lightGray {
            textField.text = nil
            textField.textColor = self.titleColor
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let inputText = textField.text else {
            return
        }
        if inputText.isEmpty {
            textField.text = self.placeholderText
            textField.textColor = UIColor.lightGray
        }
    }
}

