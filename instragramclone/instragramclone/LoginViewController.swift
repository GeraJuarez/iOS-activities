//
//  LoginViewController.swift
//  instragramclone
//
//  Created by gdaalumno on 10/23/19.
//  Copyright © 2019 gdaalumno. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!

    @IBAction func btnLogin(_ sender: Any) {
        self.logIn()
    }
    
    var PASSWORD = "Password1"
    var txtFieldTag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        txtFieldTag = 0
        emailField.delegate = self
        txtFieldTag += 1
        emailField.tag = txtFieldTag
        
        passField.delegate = self
        txtFieldTag += 1
        passField.tag = txtFieldTag
        
        hideKeyboardWhenTappedAround()
    }
    
    func logIn() {
        if self.passField.text == self.PASSWORD && self.emailField.text != "" {
            changeView()
        }
    }
    
    func changeView() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "Images")
        
        self.present(newViewController, animated: true, completion: nil)
    }

}

extension LoginViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            if textField.tag == self.txtFieldTag {
                self.logIn()
            }
        }
        
        return false
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
