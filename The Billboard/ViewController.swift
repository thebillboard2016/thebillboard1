//
//  ViewController.swift
//  The Billboard
//
//  Created by Lars Lorch on 11/29/16.
//  Copyright © 2016 The Billboard. All rights reserved.
//

import UIKit
import BuddySDK

class ViewController: UIViewController {
    
    
    // Properties
    @IBOutlet weak var usernameLoginField: UITextField!
    @IBOutlet weak var passwordLoginField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Actions
    
    // Login (Button)
    @IBAction func loginButton(_ sender: UIButton) {
        
        // Log user in
        Buddy.loginUser(usernameLoginField.text!, password: passwordLoginField.text!, callback: {
            (id: Any?, error: Error?) -> Void in
            
            if error == nil
            {
                // Segue to Map
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            }
            else
            {
                // Empty fields
                self.passwordLoginField.text?.removeAll()
                
                self.usernameLoginField.layer.cornerRadius = 6.0
                self.usernameLoginField.layer.masksToBounds = true
                self.usernameLoginField.layer.borderWidth = 1
                self.usernameLoginField.layer.borderColor = UIColor.red.cgColor
                self.passwordLoginField.layer.cornerRadius = 6.0
                self.passwordLoginField.layer.masksToBounds = true
                self.passwordLoginField.layer.borderWidth = 1
                self.passwordLoginField.layer.borderColor = UIColor.red.cgColor
                
                self.loginFailed()
            }
        })
        
    }
    
    // Segue to Register View Controller
    @IBAction func registerButton(_ sender: UIButton) {
    }
    
    
    // Segues
    @IBAction func unwindToThisViewController(segue: UIStoryboardSegue) {
        
    }
    
    func loginFailed(){
        let alertController = UIAlertController(title: "login Failed", message: "Username and password do not match, either register for an account or re-enter username and password.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present (alertController, animated: true, completion: nil)
    
}

}
