//
//  SettingViewController.swift
//  E-Hired
//
//  Created by Rui Caneira on 1/9/17.
//  Copyright © 2017 Rui Caneira. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    let JOB_SOUND_SWITCH = 101
    let MESSAGE_SOUND_SWITCH = 102
    
    @IBOutlet weak var switch_Message: UISwitch!
    @IBOutlet weak var switch_Job: UISwitch!
    @IBOutlet weak var btnNormal: DLRadioButton!
    @IBOutlet weak var btnImportant: DLRadioButton!
    @IBOutlet weak var btnAlert: DLRadioButton!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet var views: [UIView]!
    override func viewDidLoad() {
        super.viewDidLoad()
        GoogleAnalitics.send(GoogleAnalitics.SettingScreen.ScreenName)
        initView()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func initView()
    {
        for i in 0 ..< views.count
        {
            views[i].layer.cornerRadius = 8
        }
        closeBtn.layer.cornerRadius = 8
        let userDefault = NSUserDefaults.standardUserDefaults()
        switch_Job.setOn(!userDefault.boolForKey(EHNet.GET_JOBS_SOUND), animated: true)
        switch_Message.setOn(!userDefault.boolForKey(EHNet.GET_MESSAGES_SOUND), animated: true)
        let sensitivity = userDefault.integerForKey(EHNet.ALERT_SENSITIVITY)
        
        switch sensitivity {
        case 0:
            btnImportant.selected = true
        case 1:
            btnNormal.selected = true
        case 2:
            btnImportant.selected = true
        case 3:
            btnAlert.selected = true
        default:
            break
        }
    }

    @IBAction func switchChangedAction(sender: AnyObject) {
        switch (sender.tag) {
        case JOB_SOUND_SWITCH:
                saveSetting(EHNet.GET_JOBS_SOUND, value: !switch_Job.on)
            break
        case MESSAGE_SOUND_SWITCH:
                saveSetting(EHNet.GET_MESSAGES_SOUND, value: !switch_Message.on)
            break
        default:
            break
        }
    }
    @IBAction func closeAction(sender: AnyObject) {
        var sensitivity = 2
        if  btnNormal.selected
        {
            sensitivity = 1
        }
        if  btnImportant.selected
        {
            sensitivity = 2
        }
        if  btnAlert.selected
        {
            sensitivity = 3
        }
        let userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.setInteger(sensitivity, forKey: EHNet.ALERT_SENSITIVITY)
        userDefault.synchronize()
        self.navigationController?.popViewControllerAnimated(true)
    }
    func saveSetting(key: String, value: Bool)
    {
        let userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.setBool(value, forKey: key)
        userDefault.synchronize()
    }
}
