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
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
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
        
        Buddy.loginUser(usernameField.text!, password: passwordField.text!, callback: nil)
        
        
        
   
    }
    
    // Segue to Register View Controller
    @IBAction func registerButton(_ sender: UIButton) {
    }
    
    
    // Segues
    @IBAction func unwindToThisViewController(segue: UIStoryboardSegue) {
    }
    
    
    
}

