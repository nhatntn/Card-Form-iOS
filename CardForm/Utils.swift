//
//  Utils.swift
//  CardForm
//
//  Created by nhatnt on 4/15/19.
//  Copyright © 2019 nhatnt. All rights reserved.
//

import Foundation
import UIKit

func valueScaled(_ value: CGFloat) -> CGFloat {
    let designedWidthSize: CGFloat = 414
    let multiplier = UIScreen.main.bounds.width / designedWidthSize
    let scaled = value * multiplier
    
    return scaled.rounded()
}

func fontSizeScaled(_ value: CGFloat) -> CGFloat {
    let scaled = valueScaled(value)
    return scaled.rounded(.up)
}
