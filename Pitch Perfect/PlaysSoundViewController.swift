//
//  PlaysSoundViewController.swift
//  Pitch Perfect
//
//  Created by Leisa Refalo on 3/6/15.
//  Copyright (c) 2015 Leisa ReFalo. All rights reserved.
//

import UIKit
import AVFoundation

class PlaysSoundViewController: UIViewController {

    var audioPlayer : AVAudioPlayer!  // will be Optional, must supply initializer
    var audioEngine: AVAudioEngine!
    var audioFile:AVAudioFile!
    
     var recievedAudio = RecordedAudio()
    
    
     override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        audioPlayer = AVAudioPlayer()
        
        audioPlayer = AVAudioPlayer(contentsOfURL: recievedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
 
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: recievedAudio.filePathUrl, error: nil)
    
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func playSlow(sender: AnyObject) {
        playAudioFile(0.5)

    }

    @IBAction func playVadar(sender: AnyObject) {
        playAudioWithVariablePitch(-1000)
    }
    @IBAction func playChipmunk(sender: AnyObject) {
        
        playAudioWithVariablePitch(1000)
    }

    @IBAction func playFast(sender: AnyObject) {
       playAudioFile(1.5)
    }
    
    func playAudioFile(rateOfPlay:Float) {
        
        audioPlayer.stop()
        audioPlayer.rate = rateOfPlay
        audioPlayer.play()
    }

    func stopPlaying(sender: AnyObject) {
        audioPlayer.stop()
        audioEngine.stop()

    }
    
    func playAudioWithVariablePitch(pitch: Float){

        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }


}
