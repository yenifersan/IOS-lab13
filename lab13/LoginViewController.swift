//
//  LoginViewController.swift
//  lab13
//
//  Created by yenifer santiago  on 11/15/19.
//  Copyright © 2019 yenifer santiago . All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var usernamaeTextield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func loginClickButton(_ sender: Any) {
        print("login button cliked")
        if(usernamaeTextield.text != "" && passwordTextfield.text != ""){
            Auth.auth().signIn(withEmail: usernamaeTextield.text!, password: passwordTextfield.text!){
                (user, error) in
                if(user != nil) {
                    print("user authentification")
                    self.presentingViewController?.dismiss(animated: true, completion: nil);
                } else {
                    print("these was a error")
                    self.errorLabel.isHidden = false
                }
            }
        } else {
            print("these was a error")
            self.errorLabel.isHidden = false
        }

    }
}
