//
//  NormalMvcVC.swift
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
// @class NormalMvcVC
// @abstract 普通mvc的VC
// @discussion 普通mvc的VC
//

import UIKit

class NormalMvcLoginVC: LoginVC {
    
    enum LoginStaus: String {
        case logining
        case logined
        case loginError
        case nologin
    }
    
    var loginModel: LoginModel?
    
    private let minLength = 6
    //TODO: 缺点1、多出一些表状态的变量
    private var validUserName = false
    private var validPassWord = false
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    //MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getModel()
        configView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Privater Methods
    // 获取数据
    private func getModel() {
        loginModel = LoginModel()
        loginModel?.username = "123"
    }
    
    // 装配View
    private func configView() {
        loginView.username.text = loginModel?.username
        loginView.password.text = loginModel?.password
        textFieldChange(loginView.username)
        textFieldChange(loginView.password)
        loginView.username.delegate = self
        loginView.password.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(_:)), name: .UITextFieldTextDidChange, object: nil)
        loginView.loginBtn.addTarget(self, action: #selector(loginAction(_:)), for: .touchUpInside)
    }
    
    // 更新View
    private func changeLogin(status: LoginStaus) {
        if status == .logining {
            self.loginView.loginBtn.isHidden = true
            self.loginView.loading.startAnimating()
        }else if status == .logined {
            self.loginView.psTips.isHidden   = true
            self.loginView.loginBtn.isHidden = false
            self.loginView.loading.stopAnimating()
            let vc = UIAlertController(title: nil, message: "登录成功", preferredStyle: .alert)
            vc.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
            self.present(vc, animated: true, completion: nil)
        }else if status == .loginError {
            self.loginView.psTips.isHidden   = false
            self.loginView.psTips.text       = "密码错误"
            self.loginView.loginBtn.isHidden = false
            self.loginView.loading.stopAnimating()
            self.loginView.errorAnimation()
        }
    }
    
    //TODO: 缺点2、逻辑代码全写在VC，逻辑混乱，可读性差，造成VC代码冗余，无法单元测试
    private func isValidWithUserName(count: Int, text: String, isValidBlock:((Bool) -> Void)?) {
        guard count != 0 else {
            loginView.tips.isHidden = true
            isValidBlock?(false)
            return
        }
        if count < minLength, count > 0 {
            loginView.tips.isHidden = false
            loginView.tips.text     = "用户名最少\(minLength)个字符"
            isValidBlock?(false)
        }else {
            loginModel?.username = loginView.username.text ?? ""
            LoginNetwork.checkUsername(loginModel?.username ?? "", complete: { (isValid) in
                isValidBlock?(isValid)
                if isValid {
                    self.loginView.tips.isHidden = true
                }else {
                    self.loginView.tips.isHidden = false
                    self.loginView.tips.text     = "用户名不存在"
                }
            })
        }
    }
    
    private func isValidWithPassWord(count: Int, text: String) -> Bool {
        guard count != 0 else {
            loginView.psTips.isHidden = true
            return false
        }
        if count < minLength, count > 0 {
            loginView.psTips.isHidden = false
            loginView.psTips.text     = "密码最少\(minLength)个字符"
        }else {
            loginView.psTips.isHidden = true
            return true
        }
        return false
    }
    
    private func checkValid() {
        if validPassWord, validUserName {
            loginView.loginBtn.setTitleColor(.blue, for: .normal)
            loginView.loginBtn.isUserInteractionEnabled = true
        }else {
            loginView.loginBtn.setTitleColor(.gray, for: .normal)
            loginView.loginBtn.isUserInteractionEnabled = false
        }
    }
    
    private func textFieldChange(_ textField: UITextField) {
        let count = textField.text?.count ?? 0
        let text  = textField.text ?? ""
        defer {
            checkValid()
        }
        if textField == loginView.username  {
            isValidWithUserName(count: count, text: text, isValidBlock: { (isValid) in
                self.validUserName = isValid
            })
        }else if textField == loginView.password {
            validPassWord = isValidWithPassWord(count: count, text: text)
        }
    }
    
    //MARK: - Notification Methods
    @objc func textFieldDidChange(_ not: Notification) {
        if let textField = not.object as? UITextField {
            textFieldChange(textField)
        }
    }
    
    //MARK: Target Methods
    @objc func loginAction(_ btn: UIButton) {
        loginModel?.password = loginView.password.text ?? ""
        loginModel?.username = loginView.username.text ?? ""
        changeLogin(status: .logining)
        LoginNetwork.login(username: loginModel?.username ?? "", password: loginModel?.password ?? "") { (isLogin) in
            if isLogin {
                self.changeLogin(status: .logined)
            }else {
                self.changeLogin(status: .loginError)
            }
        }
    }
}

extension NormalMvcLoginVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
