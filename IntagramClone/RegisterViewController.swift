//
//  ViewController.swift
//  IntagramClone
//
//  Created by Egehan Karaköse on 4.01.2021.
//

import UIKit
import Firebase
import JGProgressHUD


class RegisterViewController: UIViewController {
    
    
    
    let btnAddPhoto: UIButton = {
        let btn = UIButton(type: .system)
        
        btn.setImage(#imageLiteral(resourceName: "Fotograf_Sec").withRenderingMode(.alwaysOriginal), for: .normal)
        // to authorize for autolayout restriction
       
        
        btn.layer.cornerRadius = btn.frame.width / 2
        btn.layer.masksToBounds = true
        
        btn.addTarget(self, action: #selector(btnAddPhotoPressed), for: .touchUpInside)
      
        return btn

    }()
    
    @objc fileprivate func btnAddPhotoPressed(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
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
    
 
    
    let txtUserName: UITextField = {
        
        let txt = UITextField()
        txt.backgroundColor = UIColor(white: 0, alpha: 0.05)
        txt.placeholder = "User Name"
        txt.borderStyle = .roundedRect
        txt.font = UIFont.systemFont(ofSize: 16)
        txt.autocorrectionType = .no
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
    
    let registerBtn : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Register", for: .normal)
        // UIColor Extension
//        btn.backgroundColor = UIColor(red: 150/255, green: 205/255, blue: 245/255, alpha: 1)
        btn.backgroundColor = UIColor.toRGB(red: 150, green: 205, blue: 245)
        btn.layer.cornerRadius = 6
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.setTitleColor(.white, for: .normal)
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(registerBtnPressed), for: .touchUpInside)
        
        return btn
    }()
    
    
    
    let loginButton: UIButton  = {
        let button = UIButton()

        let attrText = NSMutableAttributedString(string: "Do you already have an account?", attributes: [.font : UIFont.systemFont(ofSize: 16), .foregroundColor : UIColor.label])
        attrText.append(NSAttributedString(string: " Log In", attributes:  [.font : UIFont.boldSystemFont(ofSize: 16), .foregroundColor : UIColor.toRGB(red: 20, green: 155, blue: 235)]))
        button.setAttributedTitle(attrText,for: .normal)
        
        
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action:#selector(loginButtonPressed) , for: .touchUpInside)
        return button
    }()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
      
        view.addSubview(btnAddPhoto)
        view.addSubview(loginButton)
        
        
        
        btnAddPhoto.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        btnAddPhoto.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: nil, trailing: nil, paddingTop: 40, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 150, height: 150)

        createEntryFields()
    
        
        loginButton.anchor(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 50)
        
       
    }
 
    fileprivate func createEntryFields(){

        
        let stackView = UIStackView(arrangedSubviews: [txtEmail,txtUserName,txtPassword,registerBtn])

        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.heightAnchor.constraint(equalToConstant: 230)
        ])
        
        stackView.anchor(top: btnAddPhoto.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 20, paddingBottom: 0, paddingLeft: 45, paddingRight: -45, width: 0, height: 230)
        
    }
    
    
    @objc fileprivate func labelChanged(){
        let isLabelValid = (txtEmail.text?.count ?? 0) > 0 &&
            (txtPassword.text?.count ?? 0) >= 8 &&
            (txtUserName.text?.count ?? 0) > 0
        
        if isLabelValid{
            
            registerBtn.isEnabled = true
            registerBtn.backgroundColor = UIColor.toRGB(red: 20, green: 155, blue: 235)
        }else {
            registerBtn.isEnabled = false
            registerBtn.backgroundColor = UIColor.toRGB(red: 150, green: 205, blue: 245)
        }
        
        
    }
    
    
    @objc fileprivate func loginButtonPressed(){
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc fileprivate func registerBtnPressed() {
    
        guard let email = txtEmail.text, !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              let password = txtPassword.text , !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              let userName = txtUserName.text, !userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else {
            return
        }
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Registeration in Progress"
        hud.show(in: self.view)
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Failed to create user: \(error.localizedDescription)")
                hud.dismiss(animated: true)
                return
            }
            
            
            guard let registeredUserId = result?.user.uid else { return }
            let imageName = UUID().uuidString //returns random string
            
            let ref = Storage.storage().reference(withPath: "ProfilePhotos/\(imageName)")
            let imageData = self.btnAddPhoto.imageView?.image?.jpegData(compressionQuality: 0.8) ?? Data()
            
            ref.putData(imageData , metadata: nil) {(_, error) in
                if let error = error{
                    print("Profile Photo could not uploade: ", error.localizedDescription)
                    return
                }
                print("Profile Photo uploaded succesfully")
                
                
                ref.downloadURL { (url, error) in
                    if let error = error {
                        print("fail to get photo url", error.localizedDescription)
                        return
                    }
                    print("Uploaded Photo URL : \(url?.absoluteString ?? "PhotoURL")")
                    
                    let dataToAdd = ["UserName" : userName,
                                     "UserId": registeredUserId,
                                     "ProfilePhotoURL": url?.absoluteString ?? ""]
                    
                    Firestore.firestore().collection("Users").document(registeredUserId).setData(dataToAdd) {(error) in
                        if let error = error {
                            print("Fail to add UserData to FireStore : \(error.localizedDescription)")
                            return
                        }
                        print("New UserData added successfully")
                        hud.dismiss(animated: true)
                        self.clearView()
                        let keyWindow = UIApplication.shared.connectedScenes
                            .filter({$0.activationState == .foregroundActive})
                            .map({$0 as? UIWindowScene})
                            .compactMap({$0})
                            .first?.windows
                            .filter({$0.isKeyWindow}).first
                        
                        guard let mainTabBarController = keyWindow?.rootViewController as? MainTabBarController else {return}
                        mainTabBarController.presentVC()
                        self.dismiss(animated: true, completion: nil) // dismiss login vc
                        
                        print("New User created successfully: \(result?.user.uid ?? "")")
                    }
                }
            }
        }
    }
    
    fileprivate func clearView(){
        btnAddPhoto.setImage(#imageLiteral(resourceName: "Fotograf_Sec").withRenderingMode(.alwaysOriginal), for: .normal)
        btnAddPhoto.layer.borderColor = UIColor.clear.cgColor
        btnAddPhoto.layer.borderWidth = 0
        txtEmail.text = ""
        txtPassword.text = ""
        txtUserName.text = ""
        registerBtn.isEnabled = false
        let successHud = JGProgressHUD(style: .dark )
        successHud.textLabel.text = "Successfully Registered"
        successHud.show(in: self.view)
        successHud.dismiss(afterDelay: 2)
    }
}





extension UIView {
    func anchor(top : NSLayoutYAxisAnchor?,
                bottom: NSLayoutYAxisAnchor?,
                leading: NSLayoutXAxisAnchor?,
                trailing: NSLayoutXAxisAnchor?,
                paddingTop : CGFloat,
                paddingBottom: CGFloat,
                paddingLeft: CGFloat,
                paddingRight : CGFloat,
                width: CGFloat,
                height: CGFloat){
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        if let leading = leading {
            self.leadingAnchor.constraint(equalTo: leading, constant: paddingLeft).isActive = true
        }
        if let trailing = trailing {
            self.trailingAnchor.constraint(equalTo: trailing, constant: paddingRight).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
            
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
            
        }
        
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // didCancel
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.editedImage] as? UIImage
        btnAddPhoto.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        btnAddPhoto.layer.cornerRadius = btnAddPhoto.frame.width / 2
        btnAddPhoto.layer.masksToBounds = true
        btnAddPhoto.layer.borderColor = UIColor.darkGray.cgColor
        btnAddPhoto.layer.borderWidth = 3
        dismiss(animated: true, completion: nil)
    }
    
}
