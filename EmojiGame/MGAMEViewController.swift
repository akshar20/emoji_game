//
//  MGAMEViewController.swift
//  EmojiGame
//
//  Created by Shaishav Solanki on 2019-04-12.
//  Copyright © 2019 MacStudent. All rights reserved.
//

import UIKit

class MGAMEViewController: UIViewController {

    var timer:Timer!
    var timeCounter = 0.00
    var totalTime = 0.00
    
    @IBOutlet weak var emojiSeqLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.startTimer()
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    @objc func fireTimer() {
        
        self.timeCounter += 1
        
        let currentTime = String(format: "%.1f", self.timeCounter/100)
       
        self.currentTimeLabel.text = currentTime
    }
    
    @IBAction func nextSeqBtnPressed(_ sender: UIButton) {
    
        let cTime = self.currentTimeLabel.text!
        
        self.timeCounter = 0.00
        
        self.totalTime += Double(cTime)!
        
        self.totalTimeLabel.text = "\(self.totalTime)"
    
        
        
        
    }
    
}
