//
//  ViewController.swift
//  GesturePassword
//
//  Created by rongteng on 2016/10/13.
//  Copyright © 2016年 rongteng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showSetGesturePS(_ sender: UIButton) {
        let vc = GesturePasswordVC()
        vc.actionType = .set
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func showInspectGesturePS(_ sender: UIButton) {
        let vc = GesturePasswordVC()
        vc.actionType = .inspect
        present(vc, animated: true, completion: nil)
    }

}

