//
//  Helper.swift
//  GesturePassword
//
//  Created by rongteng on 2017/4/18.
//  Copyright © 2017年 rongteng. All rights reserved.
//

import Foundation


extension Int {
  public var stringValue: String {
    return String(self)
  }
}

public extension String {
  func toDouble() -> Double? {
    return NumberFormatter().number(from: self)?.doubleValue
  }
  
  func toFloat() -> Float? {
    return NumberFormatter().number(from: self)?.floatValue
  }
  
  func toInt() -> Int? {
    return NumberFormatter().number(from: self)?.intValue
  }
}
