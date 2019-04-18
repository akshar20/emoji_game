//
//  MultiPlayerViewController.swift
//  EmojiGame
//
//  Created by Shaishav Solanki on 2019-04-11.
//  Copyright © 2019 MacStudent. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class MultiPlayerViewController: UIViewController {
    
    // Firebase reference outlet
    var ref:DatabaseReference!
    var refHandle:DatabaseHandle!
    
    // User Defaults
    let sharedPreference = UserDefaults.standard
    
    // Outlets
    @IBOutlet weak var gameIDLabel: UILabel!
    @IBOutlet weak var inputGameID: UITextField!
    @IBOutlet weak var playersList: UITextView!
    @IBOutlet weak var startGameBtn: UIButton!
    
    
    // Variables
    var total_players = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Firebase reference
        ref = Database.database().reference()

    }
    
    
    // Generate Game ID
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    @IBAction func generateGameIDButton(_ sender: UIButton) {
        
        // Game id
        let randomID = self.randomString(length: 8)
    
        // Set id to the outlet
        self.gameIDLabel.text = randomID
    
        
        // Player Data
        let playerData:[String] = self.sharedPreference.array(forKey: "sharedPreferenceUserProfile") as! [String]
       
        // Add new game id to Firebase
        self.ref.child("games").child(randomID).child("leader").setValue(playerData[0])
        self.ref.child("games").child(randomID).child("gameStatus").setValue("notRunning")
        self.ref.child("games").child(randomID).child("totalPlayers").setValue("0")
        
        // Add this leader to the game
        let data = ["email": playerData[0], "name": playerData[1], "score": "0", "status": "ready", "timeConsumed": "0"]
        self.ref.child("games").child(randomID).childByAutoId().setValue(data)
        
        // set button title
        self.startGameBtn.setTitle("START GAME", for: .normal)
        
        // Add game id to the phone
        self.sharedPreference.set("\(randomID)", forKey: "sharedPreferenceGameID")

        // Update players list
        self.updatePlayersList(gameID: randomID)
        
    
    }
    
    
    // Start the Game
    @IBAction func startGameButton(_ sender: UIButton) {
        
        let gameID = self.inputGameID.text!
        
        
        if(self.startGameBtn.titleLabel?.text == "START GAME"){
            
            if(self.isKeyPresentInUserDefaults(key: "sharedPreferenceGameID")){
                let gameID = self.sharedPreference.string(forKey: "sharedPreferenceGameID")!
                self.ref.child("games/\(gameID)/gameStatus").setValue("Running")
            }
            
        }else{
            
            
            
            // Check for valid game ID
            self.ref.child("games").observeSingleEvent(of: .value, with: { (snapshot) in
                
                let name = snapshot.value as? NSDictionary
                
                let gameIDs = name?.allKeys as! [String]
                
                if(gameIDs.contains(gameID)){
                    
                    // Check player already in the game
                    var playerExist = false
                    // Player Data
                    let playerData:[String] = self.sharedPreference.array(forKey: "sharedPreferenceUserProfile") as! [String]
                    
                    
                    // Get player data to match
                    self.ref.child("games/\(gameID)").observeSingleEvent(of: .value, with: {(data) in
                        
                        let name = data.value as! Dictionary<String, Any>
                        
                        for(key, val) in name{
                            
                            if(key != "leader" && key != "gameStatus" && key != "totalPlayers"){
                                let player = val as! [String: String]
                                if (player["email"]! == playerData[0]){
                                    playerExist = true
                                    break
                                }
                                
                            }
                        }
                        
                        
                        if(playerExist == true){
                            // Already in the game
                            let alert = UIAlertController(title: "Oops..", message: "You're already in the game", preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "Okay", style: .destructive, handler: nil))
                            
                            self.present(alert, animated: true)
                            
                        }else{
                            // Add player to the game
                            let data = ["email": playerData[0], "name": playerData[1], "score": "0", "status": "ready", "timeConsumed": "0"]
                            self.ref.child("games").child(gameID).childByAutoId().setValue(data)
                            
                            // Update players list
                            self.updatePlayersList(gameID: gameID)
                        }
                        
                        
                    })
                    
                    
                    
                 
                    
                    
                }else{
                    
                    // Invalid game id
                    let alert = UIAlertController(title: "Oops..", message: "\(gameID) is not valid!", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Okay", style: .destructive, handler: nil))
                    
                    self.present(alert, animated: true)
                }
                
                
                // Observe : MULTIPLAYER LOGIC BROKEN
//                let gameId = self.sharedPreference.string(forKey: "sharedPreferenceGameID")!
//                var currentGameStatus = ""
//                self.ref.child("games/\(gameId)/gameStatus").observe(.value, with: {(data) in
//                    let stat = data.value as? String
//                    currentGameStatus = stat!
//
//                    if(currentGameStatus == "Running"){
//                        let mGameSB:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                        let mGameVC = mGameSB.instantiateViewController(withIdentifier: "mGameSB")
//                        self.present(mGameVC, animated: true, completion: nil)
//                    }
//                })
//
                
                
            })
        }
    }
    
    
    // Update players list
    func updatePlayersList(gameID: String){
    
            self.playersList.text = ""
            var players = ""
            var counter = 0
            
            // Get game data from Firebase
            self.refHandle = self.ref.child("games/\(gameID)").observe(.value, with: { (data) in
                
                let name = data.value as! Dictionary<String, Any>
                
                for(key, val) in name{
                    
                    if(key != "leader" && key != "gameStatus" && key != "totalPlayers"){
                        counter += 1
                        
                        let player = val as! [String: String]
                        let pName = player["name"]!
                        // let pEmail = player["email"]!
                        // let pScore = player["score"]!
                        
                        players += "\(counter). \(pName)\n"
                        
                        
                        
                    }else{
                        
                        if(key == "totalPlayers"){
                            self.total_players = val as! String
                            self.ref.child("games/\(gameID)/totalPlayers").setValue("\(self.total_players + 1)")
                        }
                    }
                }
                
                    self.playersList.text = players
                    players = ""
                    counter = 0
                
            })
        
        
        if(self.total_players == 2){
            let mGameSB:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let mGameVC = mGameSB.instantiateViewController(withIdentifier: "mGameSB")
            self.present(mGameVC, animated: true, completion: nil)
        }
       
    }
    
    
    
    // Check for user defaults key present
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
}
