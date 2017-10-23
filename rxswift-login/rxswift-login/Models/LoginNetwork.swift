//
//  LoginNetwork.swift
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
//  Created by 王崇磊 on 2017/10/22.
//Copyright © 2017年 王崇磊. All rights reserved.
//
// @class LoginNetwork
// @abstract 登录相关的请求，模拟网络请求
// @discussion 登录相关的请求，模拟网络请求
//

import UIKit

class LoginNetwork {
    
    // 服务器正确的账号密码
    static private let rightUserName  = "123456"
    static private let rightPassword  = "123456"
    
    
    //MARK: - Public Methods
    // 模拟异步的网络请求，效验密码
    class func login(username: String, password: String, complete:((Bool) -> Void)?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let isRight = password == rightPassword
            complete?(isRight)
        }
    }
    
    // 模拟异步的网络请求，效验用户名
    class func checkUsername(_ username: String, complete:((Bool) -> Void)?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            complete?(username == rightUserName)
        }
    }

}
