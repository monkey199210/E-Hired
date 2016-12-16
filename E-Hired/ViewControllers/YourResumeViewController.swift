//
//  TodayJobsViewController.swift
//  E-Hired
//
//  Created by Rui Caneira on 9/18/16.
//  Copyright © 2016 Rui Caneira. All rights reserved.
//

import UIKit
import Social

class YourResumeViewController: UIViewController {
    
    let SHARE_BTN = 1
    let SAVE_BTN = 2
    let MAIN_BTN = 3
    let JOBS_BTN = 4
    let MAP_BTN = 5
    let LIST_BTN = 6
    @IBOutlet weak var webView: UIWebView!
    var profile: EHProfile.Detail!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var loadingView: activityIndicator!
    
    var shareText = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.initData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func initView()
    {
        for i in 0 ..< buttons.count
        {
            buttons[i].layer.cornerRadius = 8
        }
        self.webView.scalesPageToFit = true
    }
    func initData()
    {
        self.loadingView.hidden = false
        self.loadingView.startLoading()
        Net.getProfile().onSuccess(callback: {(profileResponse) -> Void in
            let status = profileResponse.status
            if status == "ok"
            {
                self.profile = profileResponse.detail
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.loadPdf()
                self.savePDF()
            })
            self.loadingView.completeLoading(true)
            self.loadingView.hidden = true
            
        }).onFailure(callback: { (_) -> Void in
            self.loadingView.completeLoading(true)
            self.loadingView.hidden = true
        })
        
    }
    func loadPdf()
    {
        if (self.profile != nil)
        {
            if self.profile.profile_resume_url != ""
            {
                let url = NSURL(string: self.profile.profile_resume_url)
                //                let url = NSURL(string: "http://myacroyoga.com/a.pdf")
                self.webView.loadRequest(NSURLRequest(URL: url!))
                self.shareText = "Resume link is " + profile.profile_resume_url + "."
            }else{
                // load save pdf...
                if let pdfUri = getUri()
                {
                    self.webView.loadRequest(NSURLRequest(URL: pdfUri))
                }
                
            }
        }
        
    }
    @IBAction func action(sender: UIButton) {
        switch sender.tag {
        case SHARE_BTN:
            shareAction()
        case SAVE_BTN:
            saveAction()
        case MAIN_BTN:
            self.navigationController?.popToRootViewControllerAnimated(true)
        case JOBS_BTN:
            let todayJobVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TodayJobsViewController") as! TodayJobsViewController
            self.navigationController?.pushViewController(todayJobVC, animated: true)
        case MAP_BTN:
            let mapVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MapTodaysJobsViewController") as! MapTodaysJobsViewController
            self.navigationController?.pushViewController(mapVC, animated: true)
        case LIST_BTN:
            let todayJobVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TodayJobsViewController") as! TodayJobsViewController
            self.navigationController?.pushViewController(todayJobVC, animated: true)
        default:
            break
        }
    }
    func saveAction()
    {
        //        self.loadingView.hidden = false
        //        self.loadingView.startLoading()
        if self.profile != nil
        {
            savePDF()
        }
    }
    //save pdf in local
    func savePDF()
    {
        if profile.profile_resume_url == ""
        {
            return
        }
        let resumeUrl = NSURL(string: profile.profile_resume_url)
        //        let resumeUrl = NSURL(string: profile.profile_resume_url)
        if let pdfData = NSData(contentsOfURL: resumeUrl!) {
            let docURL = getUri()
            
            //Lastly, write your file to the disk.
            pdfData.writeToURL(docURL!, atomically: true)
        }
        
    }
    func shareAction()
    {
        let alertController = UIAlertController(title: nil, message:
            nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            // ...
        }
        
        let fbAction = UIAlertAction(title: "Facebook", style: .Default) { (action) in
            // ...
            self.connectFaceBook()
        }
        
        let twAction = UIAlertAction(title: "Twitter", style: .Default) { (action) in
            self.connnectTwitter()
        }
        let instagramAction = UIAlertAction(title: "Instagram", style: .Default) { (action) in
            self.connectInstagram()
        }
        alertController.addAction(fbAction)
        alertController.addAction(twAction)
        alertController.addAction(instagramAction)
        //        alertController.addAction(instagramAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    func connectFaceBook()
    {
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            let fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            fbShare.setInitialText(self.shareText)
            self.presentViewController(fbShare, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    func connnectTwitter()
    {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            
            let tweetShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            tweetShare.setInitialText(shareText)
            self.presentViewController(tweetShare, animated: true, completion: nil)
            
        } else {
            
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to tweet.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    func connectInstagram()
    {
        if let image = getThumbnail(1)
        {
            InstagramManager.sharedManager.postImageToInstagramWithCaption(image, instagramCaption: "\(self.description)", view: self.view)
        }else{
            // no pdf...
            print("can not read pdf..")
            
        }
    }
    func screenShotMethod() -> UIImage {
        self.webView.updateConstraints()
        self.webView.needsUpdateConstraints()
        //Create the UIImage
        UIGraphicsBeginImageContext(self.webView.frame.size)
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Save it to the camera roll
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        return image
    }
    func getThumbnail(pageNumber:Int) -> UIImage? {
        //        let defaults = NSUserDefaults.standardUserDefaults()
        //        let pdfUrl = defaults.objectForKey("pdf") as! String
        let docURL = getUri()
        if docURL == nil
        {
            return nil
        }
        //        let url = NSURL(fileURLWithPath: docURL)
        if let pdf:CGPDFDocumentRef = CGPDFDocumentCreateWithURL(docURL) {
            
            if let firstPage = CGPDFDocumentGetPage(pdf, pageNumber)
            {
                // Change the width of the thumbnail here
                let width:CGFloat = 620;
                
                var pageRect:CGRect = CGPDFPageGetBoxRect(firstPage, .MediaBox);
                let pdfScale:CGFloat = width/pageRect.size.width;
                pageRect.size = CGSizeMake(pageRect.size.width*pdfScale, pageRect.size.height*pdfScale);
                pageRect.origin = CGPointZero;
                
                UIGraphicsBeginImageContext(pageRect.size);
                
                let context:CGContextRef = UIGraphicsGetCurrentContext()!;
                
                // White BG
                CGContextSetRGBFillColor(context, 1.0,1.0,1.0,1.0);
                CGContextFillRect(context,pageRect);
                
                CGContextSaveGState(context);
                
                // ***********
                // Next 3 lines makes the rotations so that the page look in the right direction
                // ***********
                CGContextTranslateCTM(context, 0.0, pageRect.size.height);
                CGContextScaleCTM(context, 1.0, -1.0);
                CGContextConcatCTM(context, CGPDFPageGetDrawingTransform(firstPage, .MediaBox, pageRect, 0, true));
                
                CGContextDrawPDFPage(context, firstPage);
                CGContextRestoreGState(context);
                
                let thm:UIImage = UIGraphicsGetImageFromCurrentImageContext();
                
                UIGraphicsEndImageContext();
                return thm;
            }
        }
        return nil
    }
    
    func getUri() -> NSURL?
    {
        var docURL = (NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)).last
        docURL = docURL?.URLByAppendingPathComponent( "Resume.pdf")
        return docURL
    }
}
