//
//  SinglePlayerViewController.swift
//  EmojiGame
//
//  Created by MacStudent on 2019-04-10.
//  Copyright © 2019 MacStudent. All rights reserved.
//

import UIKit
import Firebase

class SinglePlayerViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var outputLabel: UILabel!
    
    
    lazy var vision = Vision.vision()
    let options = VisionFaceDetectorOptions()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let img = UIImage(named: "face_REClose.jpg")!
        self.imageView.image = img
    }
    
    
    
    @IBAction func identifyButtonPressed(_ sender: UIButton) {
        
        
        // High-accuracy landmark detection and face classification
        options.performanceMode = .accurate
        options.landmarkMode = .all
        options.classificationMode = .all
        options.minFaceSize = CGFloat(0.1)
        let faceDetector = vision.faceDetector(options: options)
        
        
        // [START init_faces]
        let visionImage = VisionImage(image: UIImage(named: "face_REClose.jpg")!)
    
            //1
            faceDetector.process(visionImage) { (faces, error) in
                //2
                guard error == nil, let faces = faces, !faces.isEmpty else {
                    self.dismiss(animated: true, completion: nil)
                    self.outputLabel.text = "No Face Detected"
                    return
                }
                
                var msg = ""
                
                for face in faces {
                    
                    //1 LEFT EYE
                    if face.hasLeftEyeOpenProbability {
                        if face.leftEyeOpenProbability < 0.5 {
                            msg += "1. Left Eye not Open\n"
                        } else {
                            msg += "1. Left Eye is Open\n"
                        }
                    }else{
                        msg += "1. Left Eye not Open\n"
                    }
                    
                    
                    //2 RIGHT EYE
                    if face.hasRightEyeOpenProbability {
                        if face.rightEyeOpenProbability < 0.5 {
                            msg += "2. Right Eye not Open\n"
                        } else {
                            msg += "2. Right Eye is Open\n"
                        }
                    }else{
                        msg += "2. Right Eye not Open\n"
                    }
                    
                    
                    //3 SMILE
                    if face.hasSmilingProbability {
                        if face.smilingProbability < 0.3 {
                            msg += "3. Person not smiling\n"
                        } else {
                            msg += "3. Person is smiling\n"
                        }
                    }else{
                        msg += "3. Person not smiling\n"
                    }
                    
                    self.outputLabel.text = msg
                }
            }
        
        
    
        }
    
}
