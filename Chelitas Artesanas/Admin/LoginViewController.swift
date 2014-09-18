//
//  LoginViewController.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 9/17/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import UIKit

class LoginViewController: UITableViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func login(sender: UIButton) {
        println("logging in")
        self.performSegueWithIdentifier("Login", sender: sender)
    }
}