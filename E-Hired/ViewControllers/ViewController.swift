
//
//  ViewController.swift
//  E-Hired
//
//  Created by Rui Caneira on 9/18/16.
//  Copyright © 2016 Rui Caneira. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var loadingView: activityIndicator!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingView.startLoading()
        // Do any additional setup after loading the view, typically from a nib.
        GoogleAnalitics.send(GoogleAnalitics.Splash.ScreenName)
        NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(ViewController.gotoMainViewController), userInfo: nil, repeats: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func gotoMainViewController(sender: AnyObject)
    {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let apiKey = userDefaults.objectForKey("apikey") as? String
        if (apiKey == "" || apiKey == nil){
            let mainNav = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LogInViewController") as! LogInViewController
            self.presentViewController(mainNav, animated: false, completion: nil)
            
        }else{
            
            let mainNav = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MainNav") as! UINavigationController
            self.presentViewController(mainNav, animated: false, completion: nil)
        }
    }
    
}

