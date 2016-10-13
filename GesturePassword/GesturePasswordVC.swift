//
//  GesturePasswordVC.swift
//  XiaoZhuGeJinFu
//
//  Created by rongteng on 16/6/30.
//  Copyright © 2016年 rongteng. All rights reserved.
//

import UIKit
import SnapKit


let GesturePSKey =  "GesturePSKey"

enum EntryGesturePasswordType {
    case set  //设置
    case inspect //检查
}

class GesturePasswordVC: UIViewController {
    
    var setResultClosure:((_ result:Bool)->())?
    var actionType:EntryGesturePasswordType!
    
    //公共属性
    fileprivate let drawView = GestureDrawView()
    fileprivate let noteLB = UILabel()
    
    //actionType == .Set  设置手势密码用的属性
    fileprivate let indicatorView = GesturePasswordIndicatorView()
    fileprivate var onePSStr:String?
    fileprivate var twoPSStr:String?
    
    //actionType == .inspect  检查手势密码要用的属性
    var inspectResultClosure:((_ result:Bool)->())?
    var inputPasswordNum:UInt = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addShowViews()
    }
    
    //处理当前划出的结果 并返回
    func handleResult(_ resultStr:String) -> Bool {
        
        func clearGestureTrace() {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5, execute: {
                self.drawView.enterArgin()
            })
        }
        
        if self.actionType == EntryGesturePasswordType.set {
            if resultStr.characters.count < 4 {
                clearGestureTrace()
                noteLB.text = "连接的点不能少于4个!"
                return false
            }
            self.indicatorView.setPasswordString(resultStr)
            
            if onePSStr != nil {
                twoPSStr = resultStr
                if onePSStr == twoPSStr {
                    noteLB.text = "手势密码设置成功!"
                    UserDefaults.standard.setValue(twoPSStr, forKey: GesturePSKey)
                    if setResultClosure != nil {
                        setResultClosure!(true)
                    }
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.5, execute: {
                        self.dismissPSVC()
                    })
                }else {
                    noteLB.text = "两次设置的手势密码不一致，请重新设置!"
                    indicatorView.enterArgin()
                    clearGestureTrace()
                    onePSStr = nil
                    twoPSStr = nil
                }
            }else {
                clearGestureTrace()
                noteLB.text = "请再次绘制手势密码！"
                onePSStr = resultStr
            }
            return true
        }
        
        if self.actionType == EntryGesturePasswordType.inspect {
            if resultStr.characters.count < 4 {
                clearGestureTrace()
                noteLB.text = "连接的点不能少于4个!"
                return false
            }
            
            guard let userPS = UserDefaults.standard.string(forKey: GesturePSKey) else {return false}
            
            if userPS == resultStr {
                if inspectResultClosure != nil {
                    inspectResultClosure!(true)
                }
                clearGestureTrace()
                dismissPSVC()
            }else {
                inputPasswordNum = inputPasswordNum + 1
                if inputPasswordNum == 5 {
                     noteLB.text = "输入密码错误次数过多！"
                }else {
                    clearGestureTrace()
                    noteLB.text = "密码错误，您还有\(5-inputPasswordNum)次解锁机会！"
                }
                return false
            }
        }
        return true
    }
    
    func dismissPSVC() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension GesturePasswordVC {
    
    
    func addShowViews() {
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(drawView)
        drawView.checkingPassword = {[unowned self](resultString) -> Bool in
            return self.handleResult(resultString)
        }
        drawView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(GestureDrawViewHeight)
            make.centerY.equalTo(self.view).offset(50)
        }
        
        noteLB.textColor = UIColor.black
        noteLB.font = UIFont.systemFont(ofSize: 13)
        noteLB.textAlignment = .center
        self.view.addSubview(noteLB)
        
        //如果是设置手势密码 的动作
        if actionType == .set {
            
            noteLB.text = "请绘制手势密码"
            noteLB.snp.makeConstraints({ (make) in
                make.bottom.equalTo(drawView.snp.top).offset(-35)  //设计图尺寸-50
                make.centerX.equalTo(self.view)
            })
            
            self.view.addSubview(indicatorView)
            indicatorView.snp.makeConstraints({ (make) in
                make.width.height.equalTo(40)
                make.bottom.equalTo(noteLB.snp.top).offset(-10)
                make.centerX.equalTo(self.view)
            })
           
        }
        
        if actionType == .inspect {
            noteLB.text = "请输入手势密码"
            noteLB.snp.makeConstraints({ (make) in
                make.bottom.equalTo(drawView.snp.top).offset(-40)
                make.centerX.equalTo(self.view)
            })
        }
    }
}










