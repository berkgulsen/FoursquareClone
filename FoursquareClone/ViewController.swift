//
//  ViewController.swift
//  FoursquareClone
//
//  Created by Berk Gülşen on 27.09.2023.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
       
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
       
    
    @IBAction func signInClicked(_ sender: Any) {
        if userNameText.text != "" && passwordText.text != "" {
            PFUser.logInWithUsername(inBackground: userNameText.text!, password: passwordText.text!) { user, error in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    print("welcome")
                    print(user?.username)
                }
            }
        } else {
            makeAlert(titleInput: "Error", messageInput: "Username and password cannot be null!")
        }
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        if userNameText.text != "" && passwordText.text != "" {
            let user = PFUser()
            user.username = userNameText.text
            user.password = passwordText.text
            
            user.signUpInBackground { success, error in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "error")
                } else {
                    print("logged in")
                }
            }
        } else {
            makeAlert(titleInput: "Error", messageInput: "Username or password cannot be null!")
        }
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let addButton = UIAlertAction(title: "ok", style: UIAlertAction.Style.default)
        alert.addAction(addButton)
        self.present(alert, animated: true, completion: nil)
    }
}

