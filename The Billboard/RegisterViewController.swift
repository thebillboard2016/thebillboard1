//
//  RegisterViewController.swift
//  The Billboard
//
//  Created by Lars Lorch on 11/29/16.
//  Copyright © 2016 The Billboard. All rights reserved.
//

import UIKit
import BuddySDK

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
        
        
        
        
        
        
        
        
        //-------------------------------------------
        
        // Check if form is filled out correctly 
        
        if usernameField.text!.isEmpty || emailAddressField.text!.isEmpty ||
           passwordField.text!.isEmpty || confirmPasswordField.text!.isEmpty
        {
            // Display error message
            // TODO
            
            return
        }
        if passwordField.text != confirmPasswordField.text
        {
            // Dislay error message
            // TODO
            
            passwordField.text?.removeAll()
            confirmPasswordField.text?.removeAll()
            return

        }
        
        // Check if username/emailaddress doesn't exist yet
        // TODO
        
        
        // Register User
        Buddy.createUser(usernameField.text!, password: passwordField.text!, firstName: nil, lastName: nil, email: emailAddressField.text!, dateOfBirth: nil, gender: nil, tag: nil, callback: nil)
        
        
        
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
