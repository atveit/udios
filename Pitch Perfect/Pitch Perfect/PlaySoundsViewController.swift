//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Amund Tveit on 20/03/15.
//  Copyright (c) 2015 Amund Tveit. All rights reserved.
//
// AVAudioPlayer

import UIKit
import AVFoundation // for AVAudioPlayer

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    
    var audioEngine:AVAudioEngine!
    
    var receivedAudio:RecordedAudio!
    
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
        // just to make sure volume is at max
        audioPlayer.volume = 1.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func stopSound(sender: AnyObject) {
        audioPlayer.stop()
        audioEngine.stop() // fixed critical bug, ref: review
        audioEngine.reset()

    }
    
    func playSoundWithVariableRate(rate: Float) {
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.rate = rate
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        audioPlayer.play()
    }
    
    @IBAction func playSoundFast(sender: AnyObject) {
        self.playSoundWithVariableRate(1.5)
    }
    
    @IBAction func playSoundSlowly(sender: AnyObject) {
        self.playSoundWithVariableRate(0.5)
    }
    
    @IBAction func playChipmunkAudio(sender: AnyObject) {
        playAudioWithVariablePitch(1000.0)
    }
    
    @IBAction func playDarthvaderAudio(sender: AnyObject) {
        playAudioWithVariablePitch(-1000.0)
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
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
        
        //audioPlayerNode.play()
        
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        audioEngine.startAndReturnError(nil)
        
        // max volume!
        audioPlayerNode.volume = 1.0
        
        audioPlayerNode.play()
    }
    
}
