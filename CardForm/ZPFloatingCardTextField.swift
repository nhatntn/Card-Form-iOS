//
//  ZPFloatingCardNumberField.swift
//  CardForm
//
//  Created by nhatnt on 4/10/19.
//  Copyright © 2019 nhatnt. All rights reserved.
//

import UIKit
import SnapKit

struct InputField {
    let label: UILabel
    let maxLength: Int
}

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
    
    private var inputFields = [InputField]()
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
    
    @IBInspectable var highlightColor : UIColor = UIColor.yellow {
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
        for field in inputFields {
            field.label.removeFromSuperview()
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
        
        let numberOfFields = self.cardDigits % 4 == 0 ? self.cardDigits / 4 : self.cardDigits / 4 + 1
        let widthSuperView = self.frame.width
        let widthLabel = (widthSuperView - spacing * CGFloat(numberOfFields - 1))/CGFloat(numberOfFields)
        
        for i in 0 ..< numberOfFields {
            // Create the field
            let label = UILabel()
            label.backgroundColor = .blue
            label.textAlignment = .center
            label.textColor = self.placeholderColor
            
            // Add the textfield to the view
            addSubview(label)
            
            // Add constraints
            label.snp.makeConstraints {
                $0.width.equalTo(widthLabel)
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
                        $0.left.equalTo(inputFields[i-1].label.snp.right)
                        $0.width.equalTo(spacing)
                        $0.height.equalTo(label.snp.height)
                        $0.bottom.equalToSuperview().offset(-4)
                    }
                    
                    $0.left.equalTo(seperateLabel.snp.right)
                }
            }
            
            // Add the new textfield to the input textfield array
            let maxLength = self.cardDigits % 4 != 0 && i == numberOfFields - 1 ? self.cardDigits % 4 : 4
            label.text = String(repeating: self.characterPlaceholder, count: maxLength)
            label.addTextSpacing(spacing / 10)
            
            self.inputFields.append(InputField(label: label, maxLength: maxLength))
        }
        
        let inputTextField = UITextField()
        self.addSubview(inputTextField)
        inputTextField.backgroundColor = .clear
        inputTextField.textColor = .clear
        inputTextField.tintColor = .clear
        inputTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.6)
            $0.bottom.equalToSuperview().offset(-4)
        }
        inputTextField.delegate = self
        inputTextField.addTarget(self, action: #selector(ZPFloatingCardNumberField.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
}

extension ZPFloatingCardNumberField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Always set cursor position to the end
        let newPosition = textField.endOfDocument
        textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
        
        //Check should change characters
        guard let textFieldText = textField.text, let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let subStringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - subStringToReplace.count + string.count
        
        return count <= self.cardDigits
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text?.padding(toLength: self.cardDigits, withPad: self.characterPlaceholder, startingAt: 0) else {
            return
        }
        
        let labelComponents = text.split(by: 4)
        let theNewestCharacterIndex = text.filter{ String($0) != self.characterPlaceholder }.count - 1

        for i in 0..<labelComponents.count {
            self.inputFields[i].label.text = labelComponents[i]
            self.inputFields[i].label.addTextSpacing(spacing / 10)
            var count = 0
            self.inputFields.enumerated().forEach { (index, element) in
                if index < i {
                    count += element.maxLength
                }
            }
            let theNewestCharacterCurrentLabelIndex = theNewestCharacterIndex - count
            let maxLengthCurrentLabel = self.inputFields[i].maxLength
            
            if theNewestCharacterCurrentLabelIndex > self.inputFields[i].maxLength - 1 {
                let nsRange = NSRange.init(location: 0, length: maxLengthCurrentLabel)
                let mutableString = NSMutableAttributedString(string: labelComponents[i])
                mutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: self.titleColor, range: nsRange)
                mutableString.addAttribute(NSAttributedString.Key.kern, value: spacing / 10, range: NSRange(location: 0, length: labelComponents[i].count))
                self.inputFields[i].label.attributedText = mutableString
            } else if theNewestCharacterCurrentLabelIndex >= 0 {
                let nsRangeFocus = NSRange.init(location: theNewestCharacterCurrentLabelIndex, length: 1)
                let nsRangeHighlight = NSRange.init(location: 0, length: theNewestCharacterCurrentLabelIndex)
                
                let mutableString = NSMutableAttributedString(string: labelComponents[i])
                mutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: self.highlightColor, range: nsRangeFocus)
                mutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: self.titleColor, range: nsRangeHighlight)
                mutableString.addAttribute(NSAttributedString.Key.kern, value: spacing / 10, range: NSRange(location: 0, length: labelComponents[i].count))
                self.inputFields[i].label.attributedText = mutableString
            }
        }
    }
}

extension String {
    func split(by length: Int) -> [String] {
        var startIndex = self.startIndex
        var results = [Substring]()
        
        while startIndex < self.endIndex {
            let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            results.append(self[startIndex..<endIndex])
            startIndex = endIndex
        }
        
        return results.map { String($0) }
    }
    
    func substring(with nsrange: NSRange) -> Substring? {
        guard let range = Range(nsrange, in: self) else { return nil }
        return self[range]
    }
}

extension UILabel {
    func addTextSpacing(_ letterSpacing: CGFloat) {
        guard let text = self.text else {
            return
        }
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: letterSpacing, range: NSRange(location: 0, length: text.count))
        self.attributedText = attributedString
    }
}
