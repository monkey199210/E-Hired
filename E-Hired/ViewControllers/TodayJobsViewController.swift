//
//  TodayJobsViewController.swift
//  E-Hired
//
//  Created by Rui Caneira on 9/18/16.
//  Copyright © 2016 Rui Caneira. All rights reserved.
//

import UIKit
import SwiftyJSON
import AVFoundation

class TodayJobsViewController: UIViewController {
    
    //date key
    let DATE_KEY = "today"
    @IBOutlet weak var jobTable: UITableView!
    @IBOutlet weak var loadingView: activityIndicator!
    @IBOutlet var buttons: [UIButton]!
    let MAIN_PAGE_BTN = 1
    let YOUR_PROFILE_BTN = 2
    let YOUR_RESUME_BTN = 3
    var jobs:[EHJobs.Detail] = []
    
    var timer: NSTimer!
    
    var savedate = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GoogleAnalitics.send(GoogleAnalitics.TodayJobsScreen.ScreenName)
        
        self.initView()
        loadData()
        if timer == nil
        {
            timer = NSTimer.scheduledTimerWithTimeInterval(900, target: self, selector: #selector(TodayJobsViewController.loadData), userInfo: nil, repeats: true)
        }
    }
    
    func initView()
    {
        self.loadingView.hidesWhenCompleted = true
        jobTable.registerNib(JobCell.cellNib, forCellReuseIdentifier: JobCell.id)
        for i in 0 ..< buttons.count
        {
            buttons[i].layer.cornerRadius = 8
        }
    }
    override func viewWillAppear(animated: Bool) {
    }
    func loadData()
    {
        let today = getTodayDay()
        let saveday = getSaveday()
        if today == saveday
        {
            return
        }
        
        self.loadingView.hidden = false
        self.loadingView.startLoading()
        
        Net.getJobs(nil).onSuccess(callback: {(jobList) -> Void in
            let status = jobList.status
            if status == "ok"
            {
                
                self.jobs = jobList.detail
                if self.jobs.count == 0 {
                    
                }else{
                    self.playSound()
                    self.requestJobViewed()
                    self.saveDate()
                }
                
                self.jobTable.reloadData()
            }
            self.loadingView.completeLoading(true)
            self.loadingView.hidden = true
        }).onFailure(callback: { (_) -> Void in
            self.loadingView.completeLoading(true)
            self.loadingView.hidden = true
        })

    }
    
    @IBAction func action(sender: UIButton) {
        switch sender.tag {
        case MAIN_PAGE_BTN:
            GoogleAnalitics.send(GoogleAnalitics.TodayJobsScreen.ScreenName, category: GoogleAnalitics.TodayJobsScreen.Category, action: GoogleAnalitics.TodayJobsScreen.Action, label: GoogleAnalitics.TodayJobsScreen.MAINPAGEBUTTON)
            self.navigationController?.popToRootViewControllerAnimated(true)
        case YOUR_PROFILE_BTN:
            GoogleAnalitics.send(GoogleAnalitics.TodayJobsScreen.ScreenName, category: GoogleAnalitics.TodayJobsScreen.Category, action: GoogleAnalitics.TodayJobsScreen.Action, label: GoogleAnalitics.TodayJobsScreen.PROFILEBUTTON)
            let profileVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("YourProfileViewController") as! YourProfileViewController
            self.navigationController?.pushViewController(profileVC, animated: true)
        case YOUR_RESUME_BTN:
            GoogleAnalitics.send(GoogleAnalitics.TodayJobsScreen.ScreenName, category: GoogleAnalitics.TodayJobsScreen.Category, action: GoogleAnalitics.TodayJobsScreen.Action, label: GoogleAnalitics.TodayJobsScreen.RESUMEBUTTON)
            let resumeVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("YourResumeViewController") as! YourResumeViewController
            self.navigationController?.pushViewController(resumeVC, animated: true)
        default:
            break
        }
    }
    func requestJobViewed()
    {
        var arrayList : [String: AnyObject]
        var list: [JSON] = []//data array
        if (jobs.count > 0)
        {
            for i in 0 ..< jobs.count
            {
                
                arrayList = [
                    EHNet.JOB_VIEW_JOB_SITE: jobs[i].job_site,
                    EHNet.JOB_VIEW_JOB_SITE_ID: jobs[i].job_site_id
                ]
                
                list.append(JSON(arrayList))//append to your list
                
            }
        }
        let params:[String: AnyObject] = [ EHNet.JOB_LIST_KEY: "\(list)"]
        Net.requestServer(EHNet.JOBS_VIEWED_URL, params: params ).onSuccess(callback: {(jobList) -> Void in
            print("success")
            
        }).onFailure(callback: { (_) -> Void in
            
        })
        
        
    }
    // play sound "you've got jobs"
    var player: AVAudioPlayer?
    
    func playSound() {
        let url = NSBundle.mainBundle().URLForResource("job", withExtension: "mp3")!
        
        do {
            player = try AVAudioPlayer(contentsOfURL: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error as NSError {
            print(error.description)
        }
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
    override func viewDidDisappear(animated: Bool)  {
//        let userDefault = NSUserDefaults.standardUserDefaults()
//        userDefault.setInteger(0, forKey: DATE_KEY)
//        userDefault.synchronize()
        timer.invalidate()
    }
}
extension TodayJobsViewController: UITableViewDataSource
{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(JobCell.id, forIndexPath: indexPath) as! JobCell
        cell.title.text = jobs[indexPath.row].job_title
        cell.company.text = jobs[indexPath.row].job_company
        cell.snippet.text = jobs[indexPath.row].job_snippet
        cell.address.text = jobs[indexPath.row].location_address
        return cell
    }
}
extension TodayJobsViewController:UITableViewDelegate
{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let url = jobs[indexPath.row].job_link
        if url != ""
        {
            if let link = NSURL(string: url)
            {
                UIApplication.sharedApplication().openURL(link)
            }
        }
    }
}