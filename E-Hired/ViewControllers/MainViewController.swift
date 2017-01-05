//
//  MainViewController.swift
//  E-Hired
//
//  Created by Rui Caneira on 9/18/16.
//  Copyright © 2016 Rui Caneira. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet var buttons: [UIButton]!
    let TODAY_JOBS_LISTVIEW_BTN = 1
    let YOUR_PROFILE_BTN = 2
    let SEARCH_NEW_JOBS_BTN = 3
    let MAP_TODAYS_JOBS_BTN = 4
    let YOUR_RESUME_BTN = 5
    let SEARCH_PREVIOUS_JOBS_BTN = 6
    let Message_Btn = 7
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        GoogleAnalitics.send(GoogleAnalitics.MainScreen.ScreenName)
       self.initView()
    }
    func initView()
    {
        for i in 0 ..< buttons.count
        {
            buttons[i].layer.cornerRadius = 8
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOutAction(sender: AnyObject) {
       
        logOut()
        
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
        case Message_Btn:
            GoogleAnalitics.send(GoogleAnalitics.MainScreen.ScreenName, category: GoogleAnalitics.MainScreen.Category, action: GoogleAnalitics.MainScreen.Action, label: GoogleAnalitics.MainScreen.MESSAGESBUTTON)
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
        let mainNav = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LogInViewController") as! LogInViewController
        self.presentViewController(mainNav, animated: false, completion: nil)
    }
}
