//
//  LoginViewController.swift
//  IntagramClone
//
//  Created by Egehan Karaköse on 10.01.2021.
//

import UIKit
import Firebase
import JGProgressHUD

class LoginViewController: UIViewController {
    
    let loginBtn : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Login", for: .normal)
        // UIColor Extension
//        btn.backgroundColor = UIColor(red: 150/255, green: 205/255, blue: 245/255, alpha: 1)
        btn.backgroundColor = UIColor.toRGB(red: 150, green: 205, blue: 245)
        btn.isEnabled = false
        btn.layer.cornerRadius = 6
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        
        return btn
    }()
    
    let txtEmail: UITextField = {
        
        let txt = UITextField()
        txt.backgroundColor = UIColor(white: 0, alpha: 0.05)
        txt.placeholder = "Email Address"
        txt.borderStyle = .roundedRect
        txt.textColor = .label
        txt.autocorrectionType = .no
        txt.font = UIFont.systemFont(ofSize: 16)
        txt.autocapitalizationType = .none
        txt.addTarget(self, action: #selector(labelChanged), for: .editingChanged)
        return txt
    }()
    
    
    let txtPassword: UITextField = {
        
        let txt = UITextField()
        txt.backgroundColor = UIColor(white: 0, alpha: 0.05)
        txt.placeholder = "Password"
        txt.isSecureTextEntry = true
        txt.autocorrectionType = .no
        txt.borderStyle = .roundedRect
        txt.font = UIFont.systemFont(ofSize: 16)
        txt.addTarget(self, action: #selector(labelChanged), for: .editingChanged)
        return txt
    }()
    
    
    
    let logoView : UIView = {
        
        let view = UIView()
        let imgLogo = UIImageView(image: #imageLiteral(resourceName: "Logo_Instagram"))
        imgLogo.contentMode = .scaleAspectFill
        view.addSubview(imgLogo)
        
        imgLogo.anchor(top: nil, bottom: nil, leading: nil, trailing: nil, paddingTop: 10, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 200, height: 50)
        
        imgLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imgLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.backgroundColor = UIColor.toRGB(red: 0, green: 120, blue: 175)
        return view

    }()
    
    let registerButton: UIButton  = {
        let button = UIButton()
        
        
        let attrText = NSMutableAttributedString(string: "Don't you have account?", attributes: [.font : UIFont.systemFont(ofSize: 16), .foregroundColor : UIColor.label])
        attrText.append(NSAttributedString(string: " Register Now", attributes:  [.font : UIFont.boldSystemFont(ofSize: 16), .foregroundColor : UIColor.toRGB(red: 20, green: 155, blue: 235)]))
        button.setAttributedTitle(attrText,for: .normal)
        
        
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action:#selector(registerButtonPressed) , for: .touchUpInside)
        return button
    }()
    

    @objc fileprivate func loginButtonPressed(){
        
        
        guard let email = txtEmail.text , !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              let password = txtPassword.text, !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else {
            return
        }
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loggin In ..."
        hud.show(in: view)
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Faid to Log In : \(error.localizedDescription)")
                hud.dismiss(animated: true)
                let failHud = JGProgressHUD(style: .dark)
                failHud.textLabel.text = "Failed to Logged In \(error.localizedDescription)"
                failHud.show(in: self.view)
                failHud.dismiss(afterDelay: 2)
                return
            }
            
            
            let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
            
            guard let mainTabBarController = keyWindow?.rootViewController as? MainTabBarController else {return}
            mainTabBarController.presentVC()
            self.dismiss(animated: true, completion: nil) // dismiss login vc
            
            
            hud.dismiss(animated: true)
            let successHud = JGProgressHUD(style: .dark)
            successHud.textLabel.text = "Logged In Successfully"
            successHud.show(in: self.view)
            successHud.dismiss(afterDelay: 1)
            
            
            
        }
        
        
        
        
    }
    
    @objc fileprivate func registerButtonPressed(){

        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = true
        
        view.addSubview(registerButton)
        view.addSubview(logoView)
        arrangeLoginFields()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
       
        
        registerButton.anchor(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 50)
        
        logoView.anchor(top: view.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 150)
    }
    
    
    fileprivate func arrangeLoginFields(){
        
        let stackView = UIStackView(arrangedSubviews: [txtEmail,txtPassword,loginBtn])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        view.addSubview(stackView)
        
        stackView.anchor(top: logoView.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 40, paddingBottom: 0, paddingLeft: 40, paddingRight: -40, width: 0, height: 185)
        
        
    }
    
    @objc fileprivate func labelChanged(){
        let isLabelValid = (txtEmail.text?.count ?? 0) > 0 &&
            (txtPassword.text?.count ?? 0) >= 8

        if isLabelValid{
            
            loginBtn.isEnabled = true
            loginBtn.backgroundColor = UIColor.toRGB(red: 20, green: 155, blue: 235)
        }else {
            loginBtn.isEnabled = false
            loginBtn.backgroundColor = UIColor.toRGB(red: 150, green: 205, blue: 245)
        }
        
        
    }
    
 
    
    
}
