//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Amund Tveit on 13/03/15.
//  Copyright (c) 2015 Amund Tveit. All rights reserved.
//
// Useful UIKit links from lec2
//  https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIKit_Framework/index.html
// class overview: http://img.my.csdn.net/uploads/201210/18/1350528267_1570.jpg

// navigation controller docs:
// https://developer.apple.com/library/prerelease/ios/documentation/WindowsViews/Conceptual/ViewControllerCatalog/Chapters/NavigationControllers.html
// https://developer.apple.com/library/prerelease/ios/documentation/WindowsViews/Conceptual/ViewControllerCatalog/Chapters/CombiningViewControllers.html#//apple_ref/doc/uid/TP40011313-CH6-SW1

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        // hide/show stuff here
        stopButton.hidden = true
        recordButton.enabled = true
    }
    
    // TODO: better place
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func recordAudio(sender: UIButton) {
            recordingLabel.text = "Recording in Progress"

            stopButton.hidden = false
            recordButton.enabled = false
            
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
        
        if(flag) {
            // 1. save recorded audio
            recordedAudio = RecordedAudio(fromFilePathURL: recorder.url, fromTitle: recorder.url.lastPathComponent!)
            
            // 2. perform a segue - move to play sound view
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            recordButton.enabled = true
            stopButton.hidden = true
            recordingLabel.text = "Tap to Record"
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func stopRecording(sender: UIButton) {
            stopButton.hidden = true
            recordButton.enabled = true
            recordingLabel.text = "Tap to Record"

            audioRecorder.stop()
            var audioSession = AVAudioSession.sharedInstance()
            audioSession.setActive(false, error: nil)
    }
}

