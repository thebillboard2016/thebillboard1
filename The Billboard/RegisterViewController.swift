//
//  RegisterViewController.swift
//  The Billboard
//
//  Created by Lars Lorch on 11/29/16.
//  Copyright © 2016 The Billboard. All rights reserved.
//

import UIKit
import BuddySDK
import QuartzCore

class RegisterViewController: UIViewController {
    
    // Properties

    @IBOutlet weak var emailAddressField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Register user
    
    @IBAction func registerButton(_ sender: UIButton) {
        
        
        // Check if form is filled out correctly 
        
        if usernameField.text!.isEmpty || emailAddressField.text!.isEmpty ||
           passwordField.text!.isEmpty || confirmPasswordField.text!.isEmpty
        {
            fieldNotFilled()
            if usernameField.text!.isEmpty{
                usernameField.layer.cornerRadius = 6.0
                usernameField.layer.masksToBounds = true
                usernameField.layer.borderWidth = 1
                usernameField.layer.borderColor = UIColor.red.cgColor
            }
            if emailAddressField.text!.isEmpty{
                emailAddressField.layer.cornerRadius = 6.0
                emailAddressField.layer.masksToBounds = true
                emailAddressField.layer.borderWidth = 1
                emailAddressField.layer.borderColor = UIColor.red.cgColor
            }
            if passwordField.text!.isEmpty{
                passwordField.layer.cornerRadius = 6.0
                passwordField.layer.masksToBounds = true
                passwordField.layer.borderWidth = 1
                passwordField.layer.borderColor = UIColor.red.cgColor
            }
            if confirmPasswordField.text!.isEmpty{
                confirmPasswordField.layer.cornerRadius = 6.0
                confirmPasswordField.layer.masksToBounds = true
                confirmPasswordField.layer.borderWidth = 1
                confirmPasswordField.layer.borderColor = UIColor.red.cgColor
            }
            return
        }
        
        if passwordField.text != confirmPasswordField.text
        {
            // Make password fields have a red border
            passwordField.layer.cornerRadius = 6.0
            passwordField.layer.masksToBounds = true
            passwordField.layer.borderWidth = 1
            passwordField.layer.borderColor = UIColor.red.cgColor
            confirmPasswordField.layer.cornerRadius = 6.0
            confirmPasswordField.layer.masksToBounds = true
            confirmPasswordField.layer.borderWidth = 1
            confirmPasswordField.layer.borderColor = UIColor.red.cgColor
            
            // Show error
            passwordMatchNotice()
            
            // Empty password fields
            passwordField.text?.removeAll()
            confirmPasswordField.text?.removeAll()
            return

        }
        
        // Check if password is at least of length 6 (very similar to above func.)
        if passwordField.text!.characters.count < 6
        {
            passwordField.layer.cornerRadius = 6.0
            passwordField.layer.masksToBounds = true
            passwordField.layer.borderWidth = 1
            passwordField.layer.borderColor = UIColor.red.cgColor
            confirmPasswordField.layer.cornerRadius = 6.0
            confirmPasswordField.layer.masksToBounds = true
            confirmPasswordField.layer.borderWidth = 1
            confirmPasswordField.layer.borderColor = UIColor.red.cgColor
            passwordLengthNotice()
            passwordField.text?.removeAll()
            confirmPasswordField.text?.removeAll()
            
            return
        }
        // Check if username/emailaddress doesn't exist yet
        // TODO
        
        
        // Register User
        
        Buddy.createUser(usernameField.text!, password: passwordField.text!, firstName: nil, lastName: nil, email: emailAddressField.text!, dateOfBirth: nil, gender: nil, tag: nil, callback: nil)
        
        
        // Empty fields
        usernameField.text?.removeAll()
        emailAddressField.text?.removeAll()
        passwordField.text?.removeAll()
        confirmPasswordField.text?.removeAll()
        
        // Log user out
        // Buddy.logoutUser(<#T##callback: BuddyCompletionCallback!##BuddyCompletionCallback!##(Error?) -> Void#>)

    }
    
    // Password too short error
    func passwordLengthNotice(){
        let alertController = UIAlertController(title: "Password", message: "Password must be 6 or more characters.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present (alertController, animated: true, completion: nil)
        }
    
    // Passwords do not match error
    func passwordMatchNotice(){
        let alertController = UIAlertController(title: "Password", message: "Passwords must match.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present (alertController, animated: true, completion: nil)
    }
    
    func fieldNotFilled(){
        let alertController = UIAlertController(title: "Empty Fields", message: "All fields must be filled in.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present (alertController, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
