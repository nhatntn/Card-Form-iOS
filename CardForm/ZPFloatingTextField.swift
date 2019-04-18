//
//  ZPFloatingTextField.swift
//  CardForm
//
//  Created by nhatnt on 4/10/19.
//  Copyright © 2019 nhatnt. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

@IBDesignable class ZPFloatingTextField: ZPFloatingBaseTextField {
    //MARK: TextField Delegate
    
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

