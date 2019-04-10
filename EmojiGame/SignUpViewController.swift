//
//  SignUpViewController.swift
//  EmojiGame
//
//  Created by Shaishav Solanki on 2019-04-05.
//  Copyright © 2019 MacStudent. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SignUpViewController: UIViewController {
    
    var ref:DatabaseReference!
    
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        
        let name = nameInput.text!
        let email = emailInput.text!
        let password = passwordInput.text!
        
        let data = ["name": name, "email": email, "password": password]
        
        ref.child("users").childByAutoId().setValue(data)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
