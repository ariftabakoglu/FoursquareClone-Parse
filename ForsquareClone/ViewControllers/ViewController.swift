//
//  ViewController.swift
//  ForsquareClone
//
//  Created by Arif TABAKOĞLU on 22.09.2022.
//

import UIKit
import Parse

class ViewController: UIViewController,UITextFieldDelegate{
    
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var usernameTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        passwordTextfield.delegate = self
        usernameTextfield.delegate = self
        
        }
    
    
    @IBAction func signInClicked(_ sender: Any) {
        
        if usernameTextfield.text != "" && passwordTextfield.text != ""{
            
            PFUser.logInWithUsername(inBackground: usernameTextfield.text!, password: passwordTextfield.text!) { user, error in
                
                if error != nil{
                    self.makeAlert(tittleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                }else{
                    
                    //segue
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                    
                }
            }
            
        }else{
            makeAlert(tittleInput: "Error", messageInput: "Username/Password?")
        }
        
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if usernameTextfield.text != "" && passwordTextfield.text != "" {
            
            let user = PFUser()
            user.username = usernameTextfield.text!
            user.password = passwordTextfield.text!
            
            user.signUpInBackground { success, error in
              
                if error != nil{
                    self.makeAlert(tittleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                }else{
                    
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                    
                }
            }
            
        }
        else{
            makeAlert(tittleInput: "Error", messageInput: "Username/Password ??")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
        self.switchBasedNextTextField(textField)
        
        return true
    }
    
    
    func makeAlert(tittleInput:String, messageInput:String){
        
        let alertController = UIAlertController(title: tittleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alertController.addAction(okButton)
        present(alertController, animated: true)
        
    }
    
    private func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case self.usernameTextfield:
            self.passwordTextfield.becomeFirstResponder()
        default:
            self.usernameTextfield.resignFirstResponder()
        }
    }
    
}



