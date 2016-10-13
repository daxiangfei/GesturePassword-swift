//
//  GestureDrawView.swift
//  GesturePassword
//
//  Created by rongteng on 2016/10/13.
//  Copyright © 2016年 rongteng. All rights reserved.
//

import UIKit

let XBorderMargin:CGFloat = 50 //最左边的button距离view左边的距离
let YBorderMargin:CGFloat = 10

let GestureDrawViewHeight:CGFloat = 250

let ButtonWidth:CGFloat = 40  //宽度

let LineWidth:CGFloat = 4  // 连接时 button和button之间连线的 线宽

let ScreenWidth = UIScreen.main.bounds.width


class GestureDrawView: UIView {
    
    var checkingPassword:((_ resultString:String)->(Bool))?
    
    fileprivate var success = true
    fileprivate var buttonArray = [GesturePasswordButton]()
    fileprivate var selectedButtonArray = [GesturePasswordButton]()
    
    fileprivate var touchesArray = [Dictionary<String,String>]() //记录已经连接的bt的中心位置
    fileprivate var touchedArray = [String]()  //记录结果
    
    fileprivate var lineEndPoint = CGPoint.zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        for index in 0..<9 {
            
            let view = GesturePasswordButton()
            
            let Xspace = (ScreenWidth-XBorderMargin*2-ButtonWidth*3)/2
            let Yspace = (GestureDrawViewHeight-YBorderMargin*2-ButtonWidth*3)/2
            
            let x = XBorderMargin + CGFloat(index%3) * (ButtonWidth + Xspace)
            let y = YBorderMargin + CGFloat(index/3) * (ButtonWidth + Yspace)
            
            view.frame = CGRect(x: x, y: y, width: ButtonWidth, height: ButtonWidth)
            
            addSubview(view)
            buttonArray.append(view)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lineEndPoint = CGPoint.zero
        touchedArray.removeAll()
        touchesArray.removeAll()
        success = true
        
        let touch = touches.first
        if let touch = touch {
            let touchPoint = touch.location(in: self)
            for button in buttonArray {
                //重置所有button状态
                button.selected = false
                button.success = true
                
                //如果这个点是被包含在某个button上 记录下 这个button的中心位置
                if button.frame.contains(touchPoint) {
                    let tempFrame = button.frame
                    let point = CGPoint(x: tempFrame.origin.x+tempFrame.width/2, y: tempFrame.origin.y+tempFrame.height/2)
                    let dic = ["x":"\(point.x)","y":"\(point.y)"]
                    touchesArray.append(dic)
                }
                button.setNeedsDisplay()
            }
            self.setNeedsDisplay()
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        
        if let touch = touch {
            let touchPoint = touch.location(in: self)
            for (index,button) in buttonArray.enumerated() {
                //如果这个点 被某个button包含
                if button.frame.contains(touchPoint) {
                    //如果 这个点已经被记录下来了 直接返回 并绘制
                    if touchedArray.contains("num\(index)") {
                        lineEndPoint = touchPoint;
                        self.setNeedsDisplay()
                        return;
                    }
                    
                    //添加
                    touchedArray.append("num\(index)")
                    button.selected = true
                    
                    let tempFrame = button.frame
                    let point = CGPoint(x: tempFrame.origin.x+tempFrame.width/2, y: tempFrame.origin.y+tempFrame.height/2)
                    let dic = ["x":"\(point.x)","y":"\(point.y)","num":"\(index)"]
                    touchesArray.append(dic)
                    break
                }
            }
            lineEndPoint = touchPoint
            self.setNeedsDisplay()
        }
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        var resultString = String()
        
        for dic in touchesArray {
            if dic["num"] == nil {
                break
            }
            resultString = resultString.appending(dic["num"]!)
        }
        
        if self.checkingPassword != nil {
            success =  checkingPassword!(resultString)
        }
        
        for num in touchesArray {
            let selection = Int(num["num"]!)
            let button = buttonArray[selection!]
            button.success = success
        }
        self.setNeedsDisplay()
    }
    
    
    override func draw(_ rect: CGRect) {
        
        for (index,dic) in touchesArray.enumerated() {
            if dic["num"] == nil {
                touchesArray.remove(at: index)
                continue
            }
            
            let context = UIGraphicsGetCurrentContext()
            if success {
                //橙色  //线条颜色
                context!.setStrokeColor(red: 254/255, green: 129/255, blue: 0, alpha: 1);
            }else {
                //红色
                context!.setStrokeColor(red: 251/255, green: 75/255, blue: 75/255, alpha: 1)
            }
            
            context!.setLineWidth(LineWidth);
            
            let x = CGFloat(touchesArray[index]["x"]!.toFloat()!)
            let y = CGFloat(touchesArray[index]["y"]!.toFloat()!)
            context!.move(to: CGPoint(x: x, y: y))
            
            
            if index<touchesArray.count-1 {
                let x1 = CGFloat(touchesArray[index+1]["x"]!.toFloat()!)
                let y1 = CGFloat(touchesArray[index+1]["y"]!.toFloat()!)
                context!.addLine(to: CGPoint(x: x1, y: y1))
            } else { //绘制最后一个点
                if (success) {
                    context!.addLine(to: CGPoint(x: lineEndPoint.x, y: lineEndPoint.y))
                }
            }
            context!.strokePath();
        }
    }
    
    
    func enterArgin() {
        
        touchesArray.removeAll()
        touchedArray.removeAll()
        
        for button in buttonArray {
            button.selected = false
            button.success = true
        }
        self.setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

