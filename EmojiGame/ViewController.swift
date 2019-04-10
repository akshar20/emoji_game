//
//  ViewController.swift
//  EmojiGame
//
//  Created by MacStudent on 2019-04-04.
//  Copyright © 2019 MacStudent. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class ViewController: UIViewController {
    
    
    // USER DEFAULTS
    let sharedPreference = UserDefaults.standard

    // FIREBASE DATABASE REFERENCE
    var ref:DatabaseReference!

    
    // OUTLETS
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    
    // RETRIEVED DATA
    var data = [Int : [String]]()
    
    // INDEX
    var counter = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        if(self.isKeyPresentInUserDefaults(key: "sharedPreferenceUserProfile")){
            
        
            // Jump to welcome screen
            let selectSB: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let selectVC = selectSB.instantiateViewController(withIdentifier: "selectGameSB")
            self.present(selectVC, animated: true, completion: nil)

        }
           
            ref = Database.database().reference()
            
            // Getting data from database and storing in into "data"
            ref.child("users").observe(DataEventType.childAdded, with: {(snapshot)
                in
                
                let userdata = snapshot.value! as! NSDictionary
                
                self.data[self.counter] = userdata.allValues as? [String]
                
                self.counter += 1
                
            })
        
        
    }
    
    
    // LOGIN BUTTON
    @IBAction func loginAction(_ sender: Any) {
        
        
        let email = self.emailInput.text
        let pass = self.passwordInput.text
        
        for i in 0..<self.counter{
            
            let item = data[i]!
            
            if(item[0] == email && item[2] == pass){
                
                // STORE DATA TO USER DEFAULTS
                self.sharedPreference.set(item, forKey: "sharedPreferenceUserProfile")
                
            
                
                // JUMP TO WELCOME SCREEN
                let selectSB: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let selectVC = selectSB.instantiateViewController(withIdentifier: "selectGameSB")
                self.present(selectVC, animated: true, completion: nil)
                
            }
        }
    }
    
    
    // Check key is present or not
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}

