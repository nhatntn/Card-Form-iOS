//
//  ZPFloatingTextField.swift
//  CardForm
//
//  Created by nhatnt on 4/10/19.
//  Copyright © 2019 nhatnt. All rights reserved.
//

import UIKit
import SnapKit

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
        textField.font = UIFont.systemFont(ofSize: fontSizeScaled(18.0))
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

    //MARK: Private Methods
    
    private func setupSubviews() {
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Limit the user's input to letters
        let characterSet = CharacterSet.letters.union(CharacterSet.init(charactersIn: " "))
        if string.rangeOfCharacter(from: characterSet) == nil && !string.isEmpty {
            return false
        }
        
        let currentText = textField.text ?? ""
        var newText = ""
        if range.location <= currentText.count, let textRange = Range(range, in: currentText) {
            newText = currentText.replacingCharacters(in: textRange, with: string)
        }
        
        textField.text = newText.uppercased()
        return false
    }
}

