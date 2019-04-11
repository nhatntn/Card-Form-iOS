//
//  ZPFloatingCardNumberField.swift
//  CardForm
//
//  Created by nhatnt on 4/10/19.
//  Copyright © 2019 nhatnt. All rights reserved.
//

import UIKit
import SnapKit

@IBDesignable class ZPFloatingCardNumberField: UIView {
    
    //MARK: Properties
    @IBInspectable var cardDigits : Int = 16 {
        didSet {
            setupSubviews()
        }
    }
    
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
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        self.addSubview(label)
        label.backgroundColor = .red
        label.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview()
        }
        return label
    }()
    
    private var inputFields = [UITextField]()
    @IBInspectable var placeholderColor : UIColor = UIColor.lightGray {
        didSet {
            setupSubviews()
        }
    }
    @IBInspectable var characterPlaceholder : String = "X" {
        didSet {
            setupSubviews()
        }
    }
    @IBInspectable var spacing: CGFloat = 8.0 {
        didSet {
            setupSubviews()
        }
    }
    
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
        // Clear any existing textfields
        for textField in inputFields {
            textField.removeFromSuperview()
        }
        self.subviews.forEach {
            if $0 == titleLabel {
                return
            }
            $0.removeFromSuperview()
        }
        inputFields.removeAll()
        
        self.titleLabel.text = self.title
        self.titleLabel.textColor = self.titleColor
        
        let numberOfFields = self.cardDigits % 4 == 0 ? self.cardDigits / 4 :  self.cardDigits / 4 + 1
        let widthSuperView = self.frame.width
        let widthTextField = (widthSuperView - spacing * CGFloat(numberOfFields - 1))/CGFloat(numberOfFields)
        
        for i in 0 ..< numberOfFields {
            // Create the textfield
            let textField = UITextField()
            textField.backgroundColor = .blue
            textField.textAlignment = .center

            let isLastTextField = (i == numberOfFields - 1)
            textField.text = String(repeating: self.characterPlaceholder, count: isLastTextField ? self.cardDigits % 4 : 4)
            textField.textColor = self.placeholderColor
            textField.delegate = self
            
            // Add the textfield to the view
            addSubview(textField)
            
            // Add constraints
            textField.snp.makeConstraints {
                $0.width.equalTo(widthTextField)
                $0.height.equalToSuperview().multipliedBy(0.6)
                $0.bottom.equalToSuperview().offset(-4)
                if self.inputFields.isEmpty {
                    $0.left.equalToSuperview()
                } else {
                    let seperateLabel = UILabel()
                    seperateLabel.text = "-"
                    seperateLabel.adjustsFontSizeToFitWidth = true
                    seperateLabel.font = UIFont.systemFont(ofSize: 25.0)
                    seperateLabel.textAlignment = .center
                    seperateLabel.textColor = .white
                    self.addSubview(seperateLabel)
                    seperateLabel.snp.makeConstraints {
                        $0.left.equalTo(inputFields[i-1].snp.right)
                        $0.width.equalTo(spacing)
                        $0.height.equalTo(textField.snp.height)
                        $0.bottom.equalToSuperview().offset(-4)
                    }
                    
                    $0.left.equalTo(seperateLabel.snp.right)
                }
            }
            
            // Add the new textfield to the input textfield array
            self.inputFields.append(textField)
        }
    }
    
}

extension ZPFloatingCardNumberField: UITextFieldDelegate {
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
            if textField == inputFields.last {
                textField.text = String(repeating: self.characterPlaceholder, count: self.cardDigits % 4)
            } else {
                textField.text = String(repeating: self.characterPlaceholder, count: 4)
            }
            textField.textColor = UIColor.lightGray
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text, let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let subStringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - subStringToReplace.count + string.count
        return textField == inputFields.last ? count <= self.cardDigits % 4 : count <= 4
    }
}
