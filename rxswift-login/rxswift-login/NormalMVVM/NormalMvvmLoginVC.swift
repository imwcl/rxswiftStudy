//
//  NormalMvvmVC.swift
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
// @class NormalMvvmVC
// @abstract 普通MVVM的VC
// @discussion 普通MVVM的VC
//

import UIKit

class NormalMvvmLoginVC: LoginVC {
    
    var loginModel: LoginModel?
    
    var viewModel: NormalLoginViewModel?

    //MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configView()
        configViewModel()
        getModel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Private Methods
    private func getModel() {
        viewModel?.getModel()
        viewModel?.configLoginView(loginView)
    }
    
    // View与ViewModel绑定
    private func configView() {
        loginView.username.delegate = self
        loginView.password.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(_:)), name: .UITextFieldTextDidChange, object: nil)
        loginView.loginBtn.addTarget(self, action: #selector(loginAction(_:)), for: .touchUpInside)
    }
    
    //TODO: 缺点：view、model以及ViewModel之间的双向绑定复杂
    // ViewModel与View绑定
    private func configViewModel() {
        viewModel = NormalLoginViewModel()
        
        viewModel?.usernameVaild = { [weak self] (vaildType) in
            switch vaildType {
            case .error(let str):
                self?.loginView.tips.text = str
                self?.loginView.tips.isHidden = false
            case .isVaild:
                self?.loginView.tips.isHidden = true
            }
        }
        
        viewModel?.passwordVaild = { [weak self] (vaildType) in
            switch vaildType {
            case .error(let str):
                self?.loginView.psTips.text = str
                self?.loginView.psTips.isHidden = false
            case .isVaild:
                self?.loginView.psTips.isHidden = true
            }
        }
        
        viewModel?.loginVaild = { [weak self] (isLogin) in
            if isLogin {
                self?.loginView.loginBtn.setTitleColor(.blue, for: .normal)
                self?.loginView.loginBtn.isUserInteractionEnabled = true
            }else {
                self?.loginView.loginBtn.setTitleColor(.gray, for: .normal)
                self?.loginView.loginBtn.isUserInteractionEnabled = false
            }
        }
        
        viewModel?.loginResult = { [weak self] (result) in
            self?.changeLogin(status: result)
        }
    }
    
    private func changeLogin(status: NormalLoginViewModel.LoginStaus) {
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
    
    //MARK: - Notification Methods
    @objc func textFieldDidChange(_ not: Notification) {
        if let textField = not.object as? UITextField {
            let text = textField.text
            if textField == loginView.username  {
                viewModel?.username = text
            }else if textField == loginView.password {
                viewModel?.password = text
            }
        }
    }
    
    //MARK: Target Methods
    @objc func loginAction(_ btn: UIButton) {
        viewModel?.loginTap()
    }
}

extension NormalMvvmLoginVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
