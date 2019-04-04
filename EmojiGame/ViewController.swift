//
//  ViewController.swift
//  EmojiGame
//
//  Created by MacStudent on 2019-04-04.
//  Copyright © 2019 MacStudent. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var captureSession = AVCaptureSession()
    var frontCamera:AVCaptureDevice?
    
    var cameraPreviewLayer:AVCaptureVideoPreviewLayer?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
    }


    func setupCaptureSession(){
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    func setupDevice(){
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position:  AVCaptureDevice.Position.unspecified)
        
        let devices = deviceDiscoverySession.devices
        
        for device in devices{
            if device.position == AVCaptureDevice.Position.front{
                frontCamera = device
            }
        }
    
    }
    
    func setupInputOutput(){
        do{
            let captureDeviceInput = try AVCaptureDeviceInput(device: frontCamera!)
            captureSession.addInput(captureDeviceInput)
        }catch{
            print(error)
        }
    }
    
    func setupPreviewLayer(){
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
    }
    
    func startRunningCaptureSession(){
        captureSession.startRunning()
    }
}

