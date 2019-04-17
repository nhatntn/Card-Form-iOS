//
//  ZPLineView.swift
//  CardForm
//
//  Created by nhatnt on 4/17/19.
//  Copyright © 2019 nhatnt. All rights reserved.
//

import UIKit
import SnapKit

@objcMembers
public class ZPLineView: UIView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func alignToTop() {
        self.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(1)
        }
    }
    
    public func alignToBottom() {
        self.snp.makeConstraints { make in
            make.bottom.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(1)
        }
        
    }
    
    public func alignToLeft() {
        self.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.left.equalTo(0)
            make.width.equalTo(1)
        }
    }
    
    public func alignToRight() {
        self.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.right.equalTo(0)
            make.width.equalTo(1)
        }
    }
    
    public func alignToBottomWith(leftMargin margin: Int) {
        self.snp.makeConstraints { make in
            make.bottom.equalTo(0)
            make.left.equalTo(margin)
            make.right.equalTo(0)
            make.height.equalTo(1)
        }
    }
}

