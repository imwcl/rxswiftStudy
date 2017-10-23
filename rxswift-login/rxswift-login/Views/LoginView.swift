//
//  LoginView.swift
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
// @class LoginView
// @abstract 登录的view
// @discussion 登录的view
//
import UIKit

class LoginView: UIView {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var tips: UILabel!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var psTips: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    //MARK: - Initial Methods
    static func initFormXib() -> LoginView {
        let view = UINib(nibName: "LoginView", bundle: nil).instantiate(withOwner: self, options: nil).first!
        return view as! LoginView
    }

    //MARK: - Internal Methods
    
    
    //MARK: - Public Methods
    func errorAnimation() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.values = [-5, 5, -3, 3, 0]
        animation.duration = 0.5
        animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        password.layer.add(animation, forKey: "transform.x")
    }
    
    //MARK: - Override Methods
    override func awakeFromNib() {
        loading.hidesWhenStopped = true
        loading.stopAnimating()
    }
    
    //MARK: - Privater Methods
    
    
    //MARK: - KVO Methods
    
    
    //MARK: - Notification Methods
    
    
    //MARK: - Target Methods


}
