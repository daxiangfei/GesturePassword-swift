//
//  GesturePasswordButton.swift
//  GesturePassword
//
//  Created by rongteng on 2016/10/13.
//  Copyright © 2016年 rongteng. All rights reserved.
//

import UIKit

//有三种状态
//正常、正常选中、失败选中
class GesturePasswordButton: UIView {
    
    //默认不选择
    var selected:Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    //默认是 正常选中
    var success:Bool = true  {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        if (selected) {
            if (success) {
                //成功时外圈颜色 蓝色
                context?.setStrokeColor(red: 254/255, green: 129/255, blue: 0/255,alpha: 0.2);
                //成功时 内部小圆的颜色 蓝色
                context?.setFillColor(red: 254/255, green: 129/255, blue: 0/255,alpha: 1);
            } else {
                //失败时 外圈颜色
                context?.setStrokeColor(red: 251/255, green: 75/255, blue: 75/255,alpha: 0.2);
                //失败时 内部小圆的颜色 红色
                context?.setFillColor(red: 251/255, green: 75/255, blue: 75/255,alpha: 1);
            }
            
            //绘制 圆圈内部的小圆
            let frame = CGRect(x: bounds.size.width/2-bounds.size.width/8, y: bounds.size.height/2-bounds.size.height/8, width: bounds.size.width/4, height: bounds.size.height/4);
            context?.addEllipse(in: frame);
            context?.fillPath();
            
        } else {
            //没选择时 外圈颜色 白色
            context?.setStrokeColor(red: 128/255,green: 128/255,blue: 128/255,alpha: 1);//线条颜色
        }
        
        //绘制 外圈
        context?.setLineWidth(1);
        let frame = CGRect(x: 1, y: 1, width: bounds.size.width-2, height: bounds.size.height-2);
        context?.addEllipse(in: frame);
        context?.strokePath();
        
        //如果已经选中 对内部进行渲染  不包括外圈
        //未选中时 不填充内部的
        if (selected) {
            //成功时
            if (success) {
                context?.setFillColor(red: 254/255, green: 129/255, blue: 0/255,alpha: 0.2);
            } else { //失败时
                //淡红色
                context?.setFillColor(red: 251/255, green: 75/255, blue: 75/255,alpha: 0.2);
            }
            context?.addEllipse(in: frame);
            context?.fillPath();
        }
        
    }
    
}

