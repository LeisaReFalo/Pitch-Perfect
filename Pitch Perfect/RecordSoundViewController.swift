//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Leisa Refalo on 3/5/15.
//  Copyright (c) 2015 Leisa ReFalo. All rights reserved.
//

import UIKit

import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var microphoneButton: UIButton!
    
    //Declared Globally
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    let tapText = "tap the button to start recording"
    let recordingText = "recording"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        recordingLabel.text = tapText
        microphoneButton.enabled = true
        stopButton.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func stopRecording(sender: AnyObject) {
        
            microphoneButton.enabled = true
            recordingLabel.text = tapText
            stopButton.hidden = true
        
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
    }

    @IBAction func recordAudio(sender: AnyObject) {

        
            microphoneButton.enabled = false
            recordingLabel.text = recordingText
            stopButton.hidden = false
   
        //TODO: Record the user's voice
        println("in recordAudio")
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.record()

    }
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        if (flag) { recordedAudio = RecordedAudio()
        recordedAudio.filePathUrl = recorder.url
        recordedAudio.title = recorder.url.lastPathComponent
        
        // segue to next scene
        self.performSegueWithIdentifier("playSoundSegue", sender: recordedAudio)
        }
        
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if (segue.identifier == "playSoundSegue") {
            
            // Get the new view controller using segue.destinationViewController.
            let playsSoundVC:PlaysSoundViewController = segue.destinationViewController as PlaysSoundViewController
            
            // Pass the selected object to the new view controller.
            let data = sender as RecordedAudio
            playsSoundVC.recievedAudio = data
        }
        
    }
}

