//
//  NormalLoginViewModel.swift
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
// @class NormalLoginViewModel
// @abstract 普通的ViewModel
// @discussion 普通的ViewModel
//

import UIKit

class NormalLoginViewModel {
    
    enum VaildType {
        case error(String?)
        case isVaild
    }
    
    enum LoginStaus: String {
        case logining
        case logined
        case loginError
        case nologin
    }
    
    typealias VaildBlock = ((VaildType) -> Void)?

    var aa: Bool?
    private let minLength = 6
    private var validUserName = false
    private var validPassWord = false
        
    //MARK:input
    var loginModel: LoginModel? {
        didSet {
            username = loginModel?.username
            password = loginModel?.password
        }
    }
    
    var username: String? {
        didSet {
            validWithUserName()
        }
    }
    var password: String? {
        didSet {
            validWithPassWord()
        }
    }
    @objc func loginTap() {
        loginAction()
    }
        
    //MARK: output
    //TODO: 缺点1、多出一些表状态的变量
    var usernameVaild: VaildBlock
    var passwordVaild: VaildBlock
    var loginVaild: ((Bool) -> Void)?
    var loginResult: ((LoginStaus) -> Void)?
    
    //MARK: - Initial Methods
    init() {}
    
    //MARK: - public Methods

    
    func getModel() {
        loginModel = LoginModel()
        loginModel?.username = "123"
        username =
            loginModel?.username
    }
    
    func configLoginView(_ loginView: LoginView) {
        loginView.username.text = username
        loginView.password.text = password
    }
    
    //TODO: 解决了VC代码冗余的问题，也可以进行无法单元测试
    func validWithUserName() {
        defer {
            loginVaild?(checkValid())
        }
        let count = username?.count ?? 0
        guard count != 0 else {
            usernameVaild?(.error(nil))
            validUserName = false
            return
        }
        if count < minLength, count > 0 {
            usernameVaild?(.error("用户名最少\(minLength)个字符"))
        }else {
            LoginNetwork.checkUsername(username ?? "", complete: { (isValid) in
                if isValid {
                    self.usernameVaild?(.isVaild)
                    self.validUserName = true
                    self.loginVaild?(self.checkValid())
                }else {
                    self.usernameVaild?(.error("用户名不存在"))
                }
            })
        }
        validUserName = false
    }
    
    @discardableResult
    func validWithPassWord() -> Bool {
        defer {
            loginVaild?(checkValid())
        }
        let count = password?.count ?? 0
        guard count != 0 else {
            passwordVaild?(.error(""))
            validPassWord = false
            return false
        }
        if count < minLength, count > 0 {
            passwordVaild?(.error("密码最少\(minLength)个字符"))
            return false
        }else {
            passwordVaild?(.isVaild)
            validPassWord = true
            return true
        }
    }
    
    func checkValid() -> Bool {
        return validPassWord && validUserName
    }
    
    private func loginAction() {
        self.loginResult?(.logining)
        LoginNetwork.login(username: username ?? "", password: password ?? "") { (isLogin) in
            self.loginResult?(isLogin ? LoginStaus.logined : LoginStaus.loginError)
        }
    }

}
