//
//  ViewController.swift
//  06-LoginRegisterStructure
//
//  Created by ugur-pc on 21.05.2022.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    
    private let myview: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let txtEmail: CustomTextField = {
        let txt = CustomTextField(padding: 24, height: 55)
        txt.backgroundColor = .white
        txt.keyboardType = .emailAddress
        txt.placeholder = "Email address"
        txt.layer.borderWidth = 1
        return txt
    }()
    
    private let txtPassword: CustomTextField = {
        let txt = CustomTextField(padding: 24, height: 55)
        txt.backgroundColor = .white
        txt.isSecureTextEntry = true
        txt.placeholder = "Password"
        txt.layer.borderWidth = 1
        return txt
    }()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [txtEmail, txtPassword, forgetPwTxtLabel, loginBtn, registerBtn])
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private let personImgView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "arrow.up.and.person.rectangle.portrait")
        iv.tintColor = .white
        return iv
    }()
    
    private let loginTxtLabel: UILabel = {
        let label = UILabel()
        label.font =  UIFont(name: "Zapfino", size: 55)
        label.text = "Login"
        label.textColor = .white
        return label
    }()
    
    private let forgetPwTxtLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.text = "Forgot password?"
        label.textColor = .black
        return label
    }()
    
    private let loginBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Login", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 15
        btn.backgroundColor = .blue
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        btn.addTarget(self, action: #selector(clickLoginBtn), for: .touchUpInside)
        return btn
    }()
    
    private let registerBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Register", for: .normal)
        btn.setTitleColor(UIColor(red: 16/255, green: 129/255, blue: 49/255, alpha: 1), for: .normal)
        btn.layer.cornerRadius = 15
        btn.backgroundColor = .white
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor(red: 16/255, green: 129/255, blue: 49/255, alpha: 1).cgColor
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        btn.addTarget(self, action: #selector(goRegisterVC), for: .touchUpInside)
        return btn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        
    }
    private func setupViews() {
        view.addSubview(stackView)
        view.addSubview(myview)
        view.addSubview(personImgView)
        view.addSubview(loginTxtLabel)
        forgetPwTxtLabel.textAlignment = .right
        
        //view.backgroundColor = .blue.withAlphaComponent(0.7)
        view.bringSubviewToFront(stackView)
       
        myview.layer.cornerRadius = 50
        myview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        setupShadows()
        stackView.setCustomSpacing(40, after: forgetPwTxtLabel)
        
        
        // forgot pw click handle
        forgetPwTxtLabel.isUserInteractionEnabled = true
        let guestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(clickForgotPw(_:)))
        forgetPwTxtLabel.addGestureRecognizer(guestureRecognizer)
    }
    
    private func setupShadows(){
//        myview.layer.shadowOpacity = 145
//        myview.layer.shadowRadius = 170
//        myview.layer.shadowColor = UIColor.red.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/2)
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.blue.cgColor,  UIColor.blue.cgColor]
        view.layer.addSublayer(gradientLayer)
        view.bringSubviewToFront(loginTxtLabel)
        view.bringSubviewToFront(myview)
        view.bringSubviewToFront(personImgView)
        view.bringSubviewToFront(stackView)
        
        txtEmail.layer.shadowOpacity = 2
        txtEmail.layer.shadowRadius = 2
        txtEmail.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
        
        
        txtPassword.layer.shadowOpacity = 2
        txtPassword.layer.shadowRadius = 2
        txtPassword.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
        
        loginBtn.layer.shadowOpacity = 15
        loginBtn.layer.shadowRadius = 10
        loginBtn.layer.shadowColor = UIColor.darkGray.cgColor
        loginBtn.layer.cornerRadius = 10
        
        registerBtn.layer.shadowOpacity = 1.3
        registerBtn.layer.shadowRadius = 0.7
        registerBtn.layer.shadowColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1).cgColor
        
    }
}

//MARK: - @objc funcs
extension LoginVC {
    
    // clickLoginBtn
    @objc func clickLoginBtn(){
       
        guard let email = txtEmail.text, !email.isEmpty,
              let password = txtPassword.text, !password.isEmpty else {
                  self.createAlert(title: "",
                                   msg: "Email or password is empty!",
                                   prefStyle: .alert,
                                   bgColor: .white,
                                   textColor: .black,
                                   fontSize: 25)
                  return
              }

        self.showActivityIndicator()

        // LOGIN AUTH
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            
            if let error = error {
                print(error.localizedDescription)
                self.handleFireAuthError(error: error,
                                         fontSize: 24,
                                         textColor: #colorLiteral(red: 0.9254902005, green: 0.3018482075, blue: 0.1536569698, alpha: 1),
                                         bgColor: .white)
                self.hideActivityIndicator()
                return
            }
            
            self.hideActivityIndicator()
           // self.navigationController?.pushViewController(HomeVC(), animated: true)
            let view = HomeVC()
            let nav = UINavigationController(rootViewController: view)
            self.view.window?.rootViewController = nav
        }
    }
    
    // Go RegisterVC
    @objc func goRegisterVC(){
        let view = RegisterVC()
        let nav = UINavigationController(rootViewController: view)
        self.view.window?.rootViewController = nav
    }
    
    // click forgot pw
    @objc func clickForgotPw(_ sender: Any){
     
        let view = ForgotPasswordVC()
        view.modalPresentationStyle = .overFullScreen
        self.present(view, animated: true, completion: nil)
//        let nav = UINavigationController(rootViewController: view)
//        self.view.window?.rootViewController = nav
    }
}

//MARK: -
extension LoginVC {
    private func setConstraints() {
        stackView.anchor(top: nil,
                         leading: view.leadingAnchor,
                         bottom: nil,
                         trailing: view.trailingAnchor,
                         padding: .init(top: 0, left: 30, bottom: 0, right: 30))
        stackView.centerYInSuperview()
        
        
        myview.anchor(top: view.topAnchor,
                      leading: view.leadingAnchor,
                      bottom: view.bottomAnchor,
                      trailing: view.trailingAnchor,
                      padding: .init(top: 200, left: 0, bottom: 0, right: 0))
        
        personImgView.anchor(top: view.topAnchor,
                             leading: nil,
                             bottom: nil,
                             trailing: view.trailingAnchor,
                             padding: .init(top: 120, left: 50, bottom: 50, right: 10),
                             size: .init(width: 150, height: 100))
        
        loginTxtLabel.anchor(top: view.topAnchor,
                             leading: view.leadingAnchor,
                             bottom: nil,
                             trailing: nil,
                             padding: .init(top: 14, left: 80, bottom: 30, right: 10))
    }
}
