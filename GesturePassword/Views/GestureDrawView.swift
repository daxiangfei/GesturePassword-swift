//
//  GestureDrawView.swift
//  GesturePassword
//
//  Created by rongteng on 2016/10/13.
//  Copyright © 2016年 rongteng. All rights reserved.
//

import UIKit


let ScreenWidth = UIScreen.main.bounds.width
fileprivate let XBorderMargin:CGFloat = 50 //最左边的button距离view左边的距离
fileprivate let YBorderMargin:CGFloat = 10

let GestureDrawViewHeight:CGFloat = 250
let ButtonWidth:CGFloat = 40  //宽度
let LineWidth:CGFloat = 4  // 连接时 button和button之间连线的 线宽

class GestureDrawView: UIView {
  
  var checkingPassword:((_ resultString:String) -> (Bool))?
  
  fileprivate var success = true
  fileprivate var buttonArray: [GesturePasswordButton] = []
  fileprivate var selectedButtonArray: [GesturePasswordButton] = []
  fileprivate var touchesArray: [(point: CGPoint,index: Int)] = [] //记录已经连接的bt的中心位置和其序号
  fileprivate var lineEndPoint = CGPoint.zero
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
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
    super.touchesBegan(touches, with: event)
    enterArgin()
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesMoved(touches, with: event)
    
    guard let touch = touches.first else { return }
    let touchPoint = touch.location(in: self)
    
    for (index,button) in buttonArray.enumerated() {
      //如果这个点 被某个button包含
      if button.frame.contains(touchPoint) {
        //如果 这个点已经被记录下来了 就结束
        if button.selected {
          break
        }
        button.selected = true
        let tempFrame = button.frame
        let point = CGPoint(x: tempFrame.origin.x+tempFrame.width/2, y: tempFrame.origin.y+tempFrame.height/2)
        let tup = (point,index)
        touchesArray.append(tup)
        break
      }
    }
    lineEndPoint = touchPoint
    setNeedsDisplay()
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    var resultString = ""
    //组装结果
    for tup in touchesArray  {
      resultString = resultString.appending(tup.index.stringValue)
    }
    //检查结果
    if checkingPassword != nil {
      success =  checkingPassword!(resultString)
    }
    //绘制结果
    for tup in touchesArray {
      let button = buttonArray[tup.index]
      button.success = success
    }
    setNeedsDisplay()
  }
  
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    guard let context = UIGraphicsGetCurrentContext() else {return}
    
    for (index,tup) in touchesArray.enumerated() {
      if success {
        //橙色  //线条颜色
        context.setStrokeColor(red: 254/255, green: 129/255, blue: 0, alpha: 1);
      }else {
        //红色
        context.setStrokeColor(red: 251/255, green: 75/255, blue: 75/255, alpha: 1)
      }
      context.setLineWidth(LineWidth);
      
      context.move(to: tup.point)
      if index < touchesArray.count-1 {
        let toPoint = touchesArray[index+1].point
        context.addLine(to: toPoint)
      } else { //绘制最后一个点
        if success {
          context.addLine(to: CGPoint(x: lineEndPoint.x, y: lineEndPoint.y))
        }
      }
      context.strokePath()
    }
  }
  
  //重置状态
  func enterArgin() {
    lineEndPoint = .zero
    success = true
    touchesArray.removeAll()
    for button in buttonArray {
      button.selected = false
      button.success = true
    }
    setNeedsDisplay()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
