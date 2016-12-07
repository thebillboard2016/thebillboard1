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
                // Output
                print("Login successful")
                
                // Segue to Map
                self.performSegue(withIdentifier: "loginSegue", sender: self)
                
                
            }
            else
            {
                // Output
                print("Login failed")
                
                // Empty fields
                self.passwordLoginField.text?.removeAll()
                
                // Display error message
                // TODO
                
                
            }
        })
        
    }
    
    // Segue to Register View Controller
    @IBAction func registerButton(_ sender: UIButton) {
    }
    
    
    // Segues
    @IBAction func unwindToThisViewController(segue: UIStoryboardSegue) {
        
    }
    
    
    
}

