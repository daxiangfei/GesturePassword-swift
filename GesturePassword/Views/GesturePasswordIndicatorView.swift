//
//  GesturePasswordIndicatorView.swift
//  GesturePassword
//
//  Created by rongteng on 2016/10/13.
//  Copyright © 2016年 rongteng. All rights reserved.
//

import UIKit


let CircleDiameter:CGFloat = 10.0            // 圆的直径
let CircleMargin:CGFloat =  5.0             //圆点间距

class GesturePasswordIndicatorView: UIView {
    
    var buttonArray = [IndicatorGesturePasswordButton]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        for index in 0..<9 {
            let button = IndicatorGesturePasswordButton()
            let x = CGFloat(index%3) * (CircleDiameter+CircleMargin)
            let y = CGFloat(index/3)*(CircleDiameter+CircleMargin)
            button.frame = CGRect(x: x, y: y, width: CircleDiameter, height: CircleDiameter)
            addSubview(button)
            buttonArray.append(button)
        }
        
    }
    
    func setPasswordString(_ password:String) {
        for charact in password.characters {
            let currentStr = String(charact)
            guard let currentInt = currentStr.toInt() , currentInt < 9 else {return}
            buttonArray[currentInt].selected = true
        }
    }
    
    
    func enterArgin() {
        for button in buttonArray {
            if button.selected {
                button.selected = false
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



class IndicatorGesturePasswordButton: UIView {
    
    //默认不选择
    var selected:Bool = false  {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else {return}
        
        let frame = CGRect(x: 0.5, y: 0.5, width: rect.size.width-1, height: rect.size.height-1)
        
        context.addEllipse(in: frame)
        
        //如果已经选中
        if (selected) {
            context.setFillColor(red: 254/255, green: 129/255, blue: 0/255,alpha: 1);
            context.fillPath();
        }else {
            context.setStrokeColor(red: 128/255,green: 128/255,blue: 128/255,alpha: 1);
            context.setLineWidth(0.5)
            context.strokePath()
            context.setFillColor(red: 254/255, green: 129/255, blue: 0/255,alpha: 0);
            context.fillPath()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

