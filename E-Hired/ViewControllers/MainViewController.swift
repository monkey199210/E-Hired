//
//  MainViewController.swift
//  E-Hired
//
//  Created by Rui Caneira on 9/18/16.
//  Copyright © 2016 Rui Caneira. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController {
    
    @IBOutlet var buttons: [UIButton]!
    let TODAY_JOBS_LISTVIEW_BTN = 1
    let YOUR_PROFILE_BTN = 2
    let SEARCH_NEW_JOBS_BTN = 3
    let MAP_TODAYS_JOBS_BTN = 4
    let YOUR_RESUME_BTN = 5
    let SEARCH_PREVIOUS_JOBS_BTN = 6
    let MESSAGE_BTN = 7
    let SETTING_BTN = 8
    
    let JOBSOUND = 1
    let MESSAGESOUND = 2
    
    var msgSoundMute = false
    var jobSoundMute = false
    
    var timer: NSTimer!
    var jobTimer: NSTimer!
    var savedate = 0
    var delayTimer: NSTimer!
    
    let timerInterval: Double = 900
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        GoogleAnalitics.send(GoogleAnalitics.MainScreen.ScreenName)
        self.initView()
        
        loadJobs()
        delayTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(MainViewController.MessageStart), userInfo: nil, repeats: false)
        
        if jobTimer == nil
        {
            jobTimer = NSTimer.scheduledTimerWithTimeInterval(timerInterval, target: self, selector: #selector(MainViewController.loadJobs), userInfo: nil, repeats: true)
        }
    }
    func MessageStart()
    {
        loadMessages()
        if timer == nil
        {
            timer = NSTimer.scheduledTimerWithTimeInterval(timerInterval, target: self, selector: #selector(MainViewController.loadMessages), userInfo: nil, repeats: true)
        }
    }
    func initView()
    {
        for i in 0 ..< buttons.count
        {
            buttons[i].layer.cornerRadius = 8
        }
        
        //get setting
        let userDefault = NSUserDefaults.standardUserDefaults()
        msgSoundMute = userDefault.boolForKey(EHNet.GET_MESSAGES_SOUND)
        jobSoundMute = userDefault.boolForKey(EHNet.GET_JOBS_SOUND)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOutAction(sender: AnyObject) {
        
        logOut()
        
    }
    func loadMessages()
    {
        let userDefault = NSUserDefaults.standardUserDefaults()
        var sensitivity = userDefault.integerForKey(EHNet.ALERT_SENSITIVITY)
        if sensitivity == 0
        {
            sensitivity = 2
        }
        Net.checkNewMessage(sensitivity).onSuccess(callback: {(response) -> Void in
            let status = response.status
            if status == "ok"
            {
                if Int(response.result) > 0 && !self.msgSoundMute
                {
                    self.playSound(self.MESSAGESOUND)
                }
            }else{
                //                self.showErrorAlert(message.error)
            }
        }).onFailure(callback: { (error) -> Void in
        })
        
    }
    func loadJobs()
    {
        let today = getTodayDay()
        let saveday = getSaveday()
        if today == saveday
        {
            return
        }
        
        Net.getJobs(nil).onSuccess(callback: {(jobList) -> Void in
            let status = jobList.status
            if status == "ok"
            {
                let jobs = jobList.detail
                if jobs.count == 0 {
                    
                }else{
                    if !self.jobSoundMute
                    {
                        self.playSound(self.JOBSOUND)
                        self.saveDate()
                    }
                }
            }
        }).onFailure(callback: { (_) -> Void in
        })
        
    }
    // save current date in userdefault for verify today.
    func saveDate()
    {
        let day = getTodayDay()
        //        let userDefault = NSUserDefaults.standardUserDefaults()
        //        userDefault.setInteger(day, forKey: DATE_KEY)
        //        userDefault.synchronize()
        savedate = day
    }
    func getSaveday() -> Int
    {
        //        let userDefaults = NSUserDefaults.standardUserDefaults()
        //        let day = userDefaults.integerForKey(DATE_KEY)
        return savedate
    }
    func getTodayDay() -> Int
    {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day], fromDate: date)
        let day = components.day
        return day
    }
    
    
    var player: AVAudioPlayer?
    func playSound(what: Int) {
        var url = NSBundle.mainBundle().URLForResource("message", withExtension: "mp3")!
        if what == JOBSOUND
        {
            url = NSBundle.mainBundle().URLForResource("job", withExtension: "mp3")!
        }
        do {
            player = try AVAudioPlayer(contentsOfURL: url)
            player?.volume = 1.0
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    @IBAction func action(sender: UIButton) {
        
        switch sender.tag {
        case TODAY_JOBS_LISTVIEW_BTN:
            GoogleAnalitics.send(GoogleAnalitics.MainScreen.ScreenName, category: GoogleAnalitics.MainScreen.Category, action: GoogleAnalitics.MainScreen.Action, label: GoogleAnalitics.MainScreen.TODAYJOBBUTTON)
            break
        case YOUR_PROFILE_BTN:
            GoogleAnalitics.send(GoogleAnalitics.MainScreen.ScreenName, category: GoogleAnalitics.MainScreen.Category, action: GoogleAnalitics.MainScreen.Action, label: GoogleAnalitics.MainScreen.PROFILEBUTTON)
            break
        case SEARCH_NEW_JOBS_BTN:
            GoogleAnalitics.send(GoogleAnalitics.MainScreen.ScreenName, category: GoogleAnalitics.MainScreen.Category, action: GoogleAnalitics.MainScreen.Action, label: GoogleAnalitics.MainScreen.SEARCHNEWJOBSBUTTON)
            break
        case MAP_TODAYS_JOBS_BTN:
            GoogleAnalitics.send(GoogleAnalitics.MainScreen.ScreenName, category: GoogleAnalitics.MainScreen.Category, action: GoogleAnalitics.MainScreen.Action, label: GoogleAnalitics.MainScreen.MAPTODAYSJOBBUTTON)
            break
        case YOUR_RESUME_BTN:
            GoogleAnalitics.send(GoogleAnalitics.MainScreen.ScreenName, category: GoogleAnalitics.MainScreen.Category, action: GoogleAnalitics.MainScreen.Action, label: GoogleAnalitics.MainScreen.RESUMEBUTTON)
            break
        case SEARCH_PREVIOUS_JOBS_BTN:
            GoogleAnalitics.send(GoogleAnalitics.MainScreen.ScreenName, category: GoogleAnalitics.MainScreen.Category, action: GoogleAnalitics.MainScreen.Action, label: GoogleAnalitics.MainScreen.SEARCHPREVIOUSJOBSBUTTON)
            break
        case MESSAGE_BTN:
            GoogleAnalitics.send(GoogleAnalitics.MainScreen.ScreenName, category: GoogleAnalitics.MainScreen.Category, action: GoogleAnalitics.MainScreen.Action, label: GoogleAnalitics.MainScreen.MESSAGESBUTTON)
            break
        case SETTING_BTN:
            GoogleAnalitics.send(GoogleAnalitics.MainScreen.ScreenName, category: GoogleAnalitics.MainScreen.Category, action: GoogleAnalitics.MainScreen.Action, label: GoogleAnalitics.MainScreen.SETTINGBUTTON)
            break
        default:
            break
        }
        
    }
    func logOut(){
        GoogleAnalitics.send(GoogleAnalitics.MainScreen.ScreenName, category: GoogleAnalitics.MainScreen.Category, action: GoogleAnalitics.MainScreen.Action, label: GoogleAnalitics.MainScreen.LOGOUTBUTTON)
        let userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.setObject("", forKey: "apikey")
        userDefault.synchronize()
        if jobTimer != nil
        {
            jobTimer.invalidate()
            jobTimer = nil
        }
        if timer != nil
        {
            timer.invalidate()
            
            timer = nil
        }
        if delayTimer != nil
        {
            delayTimer.invalidate()
            delayTimer = nil
        }
//        let mainNav = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LogInViewController") as! LogInViewController
//        self.presentViewController(mainNav, animated: false, completion: nil)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.logOut()
    }
    
}
