//
//  ZPFloatingDateTextField.swift
//  CardForm
//
//  Created by nhatnt on 4/15/19.
//  Copyright © 2019 nhatnt. All rights reserved.
//

import UIKit
import SnapKit

@IBDesignable class ZPFloatingDateTextField: UIView {
    
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
        label.textAlignment = .center
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
            $0.bottom.equalToSuperview().offset(valueScaled(-8))
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
        self.titleLabel.font = UIFont.systemFont(ofSize: fontSizeScaled(10.0))
        
        self.inputTextField.text = self.placeholderText
        self.inputTextField.textColor = self.placeholderColor
        self.inputTextField.textAlignment = .center
        self.inputTextField.delegate = self
        
        let widthTextInTextField = inputTextField.text?.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: fontSizeScaled(25.0))]).width ?? inputTextField.frame.width
        let line = ZPLineView()
        line.backgroundColor = self.titleColor
        self.addSubview(line)
        line.snp.makeConstraints {
            $0.width.equalTo(widthTextInTextField)
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
    }
    
}

extension ZPFloatingDateTextField: UITextFieldDelegate {
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard var text = textField.text as NSString? else {
            return false
        }
        
        //Limit the user's input to numbers
        if string.rangeOfCharacter(from: CharacterSet.decimalDigits) == nil && !string.isEmpty {
            return false
        }
        
        // If we're trying to add more than the max amount of characters, don't allow it
        if text.length == 5 && range.location > 5 {
            return false
        }
        text = text.replacingCharacters(in: range, with: string) as NSString
        
        //Now remove spaces, periods, and slashes (since we'll add these automatically in a minute)
        text = text.replacingOccurrences(of: "/", with: "") as NSString
        
        guard let mutableText = text.mutableCopy() as? NSMutableString else {
            return false
        }
        if text.length > 2 {
            mutableText.insert("/", at: 2)
        }
        
        //set text to new string
        text = mutableText
        
        // Now, lets check if we need to cut off extra characters (like if the person pasted a too-long string)
        if text.length > 5 {
            text = text.replacingCharacters(in: NSRange(location: 5, length: mutableText.length - 5), with: "") as NSString
        }

        textField.text = String(text)
        return false
    }

}

