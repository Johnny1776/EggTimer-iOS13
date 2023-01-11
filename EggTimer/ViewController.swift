//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class ViewController: UIViewController {
    
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    let eggTimes = ["Soft": 5, "Medium": 7, "Hard": 10]
    var seconds = 60 //This variable will hold a starting value of seconds. It could be any amount above 0.
    var timer = Timer()
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    var startSeconds = 100
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"H:%02i M:%02i S:%02i", hours, minutes, seconds)
    }
    
    fileprivate func setVisibility(set: Bool) {
        btnCancel.isHidden = set
        progressBar.isHidden = set
        progressBar.setProgress(0, animated: false)
    }
    
    @IBAction func btnCancelPressed(_ sender: Any) {
        setVisibility(set: true)
        timer.invalidate()
        seconds = 0
        updateTimeLabel()

    }
    
    @objc func updateTimer() {
        if seconds <= 0 {
            //Stop the timer and play the bell. Clicking a button should stop the sound and clear the time.
            //Display the Stop button.
            playAlarm()
            timerLabel.text = "READY!"
        }else{
            seconds -= 1
            updateTimeLabel()
        }
    }

    func updateTimeLabel(){
        timerLabel.text = "\(timeString(time: TimeInterval(seconds) ))" //This will update the label.
        let progressSeconds = 1 - (Float(seconds) / Float(startSeconds))
        progressBar.setProgress(progressSeconds, animated: true)
        
    }
    
    func playAlarm() {
        
        // create a sound ID, in this case its the tweet sound.
        AudioServicesPlaySystemSound(SystemSoundID(1005))
    }
    
    func runTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        timer.invalidate()
        startSeconds = eggTimes[sender.currentTitle!]! * 60
        seconds = startSeconds
        runTimer()
        setVisibility(set: false)

        switch sender.currentTitle! {
                case "Soft":
            print("We Found Soft")
        case "Medium":
            print("We Found Medium")
        case "Hard":
            print("We Found Hard")
        default:
            print("Nothing Found. Error.")
        }
    }
}
