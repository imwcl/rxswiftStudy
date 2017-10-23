//
//  LoginVC.swift
//  rxswift-login
//
// **************************************************
// *                                  _____         *
// *         __  _  __     ___        \   /         *
// *         \ \/ \/ /    / __\       /  /          *
// *          \  _  /    | (__       /  /           *
// *           \/ \/      \___/     /  /__          *
// *                               /_____/          *
// *                                                *
// **************************************************
//  Github  :https://github.com/imwcl
//  HomePage:http://imwcl.com
//  CSDN    :http://blog.csdn.net/wang631106979
//
//  Created by 王崇磊 on 2017/10/20.
//Copyright © 2017年 王崇磊. All rights reserved.
//
// @class LoginVC
// @abstract 登录的基类VC
// @discussion 登录的基类VC
//

import UIKit

class LoginVC: UIViewController {
    
    let loginView: LoginView = { LoginView.initFormXib() }()

    //MARK: - Initial Methods
    
    
    //MARK: - Internal Methods
    func addLoginView() {
        loginView.frame = view.bounds
        view.addSubview(loginView)
    }
    
    //MARK: - Public Methods
    
    
    //MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addLoginView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    //MARK: - Privater Methods
    
    
    //MARK: - KVO Methods
    
    
    //MARK: - Notification Methods
    
    
    //MARK: - Target Methods


}
