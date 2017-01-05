//
//  TodayJobsViewController.swift
//  E-Hired
//
//  Created by Rui Caneira on 9/18/16.
//  Copyright © 2016 Rui Caneira. All rights reserved.
//

import UIKit
import Social

class YourProfileViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    
    @IBOutlet var checkImg: [UIImageView]!
    
    @IBOutlet var skills: [UITextField]!
    @IBOutlet weak var introduce: UITextView!

    @IBOutlet weak var educationLabel: UITextField!
    @IBOutlet weak var salaryLabel: UITextField!
    @IBOutlet weak var availableLabel: UITextField!
    @IBOutlet weak var zipcodeLabel: UITextField!
    @IBOutlet weak var industryLabel: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    

    @IBOutlet weak var scrollBottom: NSLayoutConstraint!
    
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var loadingView: activityIndicator!
    @IBOutlet weak var skillView: UIView!
    var profile: EHProfile.Detail!
    let EDIT_BTN = 1
    let SAVE_BTN = 2
    let SHARE_BTN = 3
    let MAIN_BTN = 4
    let JOBS_BTN = 5
    let MAP_BTN = 6
    let LIST_BTN = 7
    let EDIT_PHOTO_BTN = 8
    let INDUSTRY_BTN = 9
    let AVAILABILITY_BTN = 10
    let SALARY_BTN = 11
    let EDUCATION_BTN = 12
    
    var editFlag = false
    
    var shareText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GoogleAnalitics.send(GoogleAnalitics.ProfileScreen.ScreenName)
        initView()
        initData()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(YourProfileViewController.keyboardWillChangeFrame(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(YourProfileViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func initView()
    {
        for i in 0 ..< buttons.count
        {
            buttons[i].layer.cornerRadius = 8
        }
        avatarImg.setNeedsLayout()
        avatarImg.layoutIfNeeded()
        avatarImg.layer.borderWidth = 2.0
        avatarImg.layer.masksToBounds = false
        avatarImg.layer.borderColor = UIColor.yellowColor().CGColor
        avatarImg.layer.cornerRadius = avatarImg.frame.size.width/2.0
        avatarImg.clipsToBounds = true
        
        for i in 0 ..< skills.count
        {
            skills[i].delegate = self
        }
        
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
                self.configureProfile()
            }
            self.loadingView.completeLoading(true)
            self.loadingView.hidden = true
        }).onFailure(callback: { (_) -> Void in
            self.loadingView.completeLoading(true)
            self.loadingView.hidden = true
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func configureProfile()
    {
        let path = profile.profile_picture
        if let url = NSURL(string: path!)
        {
            avatarImg.nk_cancelLoading()
            avatarImg.nk_setImageWith(url)
        }
        nameLabel.text = "\(profile.user_first_name) \(profile.user_last_name)"
        emailLabel.text = profile.user_email
        zipcodeLabel.text = profile.user_zip_code
        industryLabel.text = profile.profile_industry
        availableLabel.text = profile.profile_availability
        salaryLabel.text = profile.profile_salary
        educationLabel.text = profile.profile_education
        introduce.text = profile.profile_objective
        let skillList = profile.profile_skills!
        for i in 0 ..< skillList.count
        {
            skills[i].text = skillList[i]
        }
    }
    @IBAction func action(sender: UIButton) {
        let pickerVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PickerViewController") as! PickerViewController
        pickerVC.profileVC = self
        switch sender.tag {
        case EDIT_BTN:
            GoogleAnalitics.send(GoogleAnalitics.ProfileScreen.ScreenName, category: GoogleAnalitics.ProfileScreen.Category, action: GoogleAnalitics.ProfileScreen.Action, label: GoogleAnalitics.ProfileScreen.EDITBUTTON)
            editAction()
            editFlag = true
        case SAVE_BTN:
            GoogleAnalitics.send(GoogleAnalitics.ProfileScreen.ScreenName, category: GoogleAnalitics.ProfileScreen.Category, action: GoogleAnalitics.ProfileScreen.Action, label: GoogleAnalitics.ProfileScreen.SAVEBUTTON)
            if editFlag
            {
                saveAction()
                editFlag = false
            }
        case SHARE_BTN:
            shareAction()
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
        case EDIT_PHOTO_BTN:
            if editFlag
            {
                changePhotoAction()
            }
        case INDUSTRY_BTN:
            if editFlag
            {
                pickerVC.selectedItem = industryLabel.text!
                pickerVC.index = 0
                self.navigationController?.pushViewController(pickerVC, animated: true)
            }
        
        case AVAILABILITY_BTN:
            if editFlag
            {
                pickerVC.selectedItem = availableLabel.text!
                pickerVC.index = 1
                self.navigationController?.pushViewController(pickerVC, animated: true)
            }
        case SALARY_BTN:
            if editFlag
            {
                pickerVC.selectedItem = salaryLabel.text!
                pickerVC.index = 2
                self.navigationController?.pushViewController(pickerVC, animated: true)
            }
        case EDUCATION_BTN:
            if editFlag
            {
                pickerVC.selectedItem = educationLabel.text!
                pickerVC.index = 3
                self.navigationController?.pushViewController(pickerVC, animated: true)
            }
        default:
            break
        }
    }
    func changeInfo(index: Int, str: String)
    {
        switch index {
        case 0:
            industryLabel.text = str
        case 1:
            availableLabel.text = str
        case 2:
            salaryLabel.text = str
        case 3:
            educationLabel.text = str
        default:
            break
        }
    }
    func editAction()
    {
            nameLabel.userInteractionEnabled = true
            emailLabel.userInteractionEnabled = true
            zipcodeLabel.userInteractionEnabled = true
            introduce.editable = true
            for i in 0 ..< skills.count
            {
                skills[i].userInteractionEnabled = true
            }
    }
    func saveAction()
    {
        nameLabel.userInteractionEnabled = false
        emailLabel.userInteractionEnabled = false
        zipcodeLabel.userInteractionEnabled = false
        introduce.editable = false
        for i in 0 ..< skills.count
        {
            skills[i].userInteractionEnabled = false
        }
        let fullName = nameLabel.text
        let fullNameArr = fullName!.characters.split{$0 == " "}.map(String.init)
        let firstName: String = fullNameArr[0]
        let lastName: String? = fullNameArr.count > 1 ? fullNameArr[1] : ""
//        if strSplit.count > 1
//        {
//            firstName = String(strSplit.first)
//            lastName = String(strSplit.last)
//        }else {
//            firstName = String(strSplit.first)
//        }
        
        let image = self.avatarImg.image
        let params: [String: AnyObject] = [EHNet.USER_FIRST_NAME: firstName as AnyObject,
            EHNet.USER_LAST_NAME: lastName as! AnyObject,
            EHNet.USER_EMAIL: emailLabel.text! as AnyObject,
            EHNet.USER_ZIP_CODE: zipcodeLabel.text! as AnyObject,
            EHNet.PROFILE_OBJECTIVE: introduce.text! as AnyObject,
            EHNet.PROFILE_SALARY: salaryLabel.text! as AnyObject,
            EHNet.PROFILE_INDUSTRY: industryLabel.text! as AnyObject,
            EHNet.PROFILE_EDUCATION: educationLabel.text! as AnyObject,
            EHNet.PROFILE_AVALABILITY: availableLabel.text! as AnyObject,
            EHNet.SKILL0: skills[0].text! as AnyObject,
            EHNet.SKILL1: skills[1].text! as AnyObject,
            EHNet.SKILL2: skills[2].text! as AnyObject,
            EHNet.SKILL3: skills[3].text! as AnyObject,
            EHNet.SKILL4: skills[4].text! as AnyObject,
            EHNet.SKILL5: skills[5].text! as AnyObject,
            EHNet.SKILL6: skills[6].text! as AnyObject,
            EHNet.SKILL7: skills[7].text! as AnyObject]
        
        self.loadingView.hidden = false
        self.loadingView.startLoading()

        Net.uploadProfile(params).onSuccess(callback: { (_) -> Void in
            Net.uploadProfileImage(image!).onSuccess(callback: { (_) -> Void in
                //                let now =
                self.loadingView.completeLoading(true)
                self.loadingView.hidden = true
            }).onFailure { (error) -> Void in
                self.loadingView.completeLoading(false)
                self.loadingView.hidden = true
                //            UIAlertView(title: "ERROR", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
            }
        }).onFailure { (error) -> Void in
            self.loadingView.completeLoading(false)
            self.loadingView.hidden = true
//            UIAlertView(title: "ERROR", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
        }
        
    }
    func replaceSpace(str: String) -> String
    {
        return str.stringByReplacingOccurrencesOfString(" ", withString: "%20")
    }
    func shareAction()
    {
        self.shareText = "Profile name is " + nameLabel.text! + "."
        let alertController = UIAlertController(title: nil, message:
            nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            // ...
        }
        
        let fbAction = UIAlertAction(title: "Facebook", style: .Default) { (action) in
            // ...
            GoogleAnalitics.send(GoogleAnalitics.ProfileScreen.ScreenName, category: GoogleAnalitics.ProfileScreen.Category, action: GoogleAnalitics.ProfileScreen.Action, label: GoogleAnalitics.ProfileScreen.FACEBOOKSHAREBUTTON)
            self.connectFaceBook()
        }
        
        let twAction = UIAlertAction(title: "Twitter", style: .Default) { (action) in
            GoogleAnalitics.send(GoogleAnalitics.ProfileScreen.ScreenName, category: GoogleAnalitics.ProfileScreen.Category, action: GoogleAnalitics.ProfileScreen.Action, label: GoogleAnalitics.ProfileScreen.TWITTERSHAREBUTTON)
            self.connnectTwitter()
        }
//        let instagramAction = UIAlertAction(title: "Instagram", style: .Default) { (action) in
//            self.connectInstagram()
//        }
        alertController.addAction(fbAction)
        alertController.addAction(twAction)
//        alertController.addAction(instagramAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    func connectFaceBook()
    {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            let fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            fbShare.setInitialText(shareText)
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
    private var documentController:UIDocumentInteractionController!
    func connectInstagram()
    {
        let instagramUrl = NSURL(string: "instagram://app")
        if(UIApplication.sharedApplication().canOpenURL(instagramUrl!)){
            
            //Instagram App avaible
            
            let imageData = UIImageJPEGRepresentation(avatarImg.image!, 100)
            let captionString = "Your Caption"
            let writePath = NSTemporaryDirectory().stringByAppendingString("instagram.igo")
            
            if(!imageData!.writeToFile(writePath, atomically: true)){
                //Fail to write. Don't post it
                return
            } else{
                //Safe to post
                
                let fileURL = NSURL(fileURLWithPath: writePath)
                self.documentController = UIDocumentInteractionController(URL: fileURL)
                self.documentController.delegate = nil
                self.documentController.UTI = "com.instagram.exclusivegram"
                self.documentController.annotation =  NSDictionary(object: captionString, forKey: "InstagramCaption")
                self.documentController.presentOpenInMenuFromRect(self.view.frame, inView: self.view, animated: true)
            }
        } else {
            //Instagram App NOT avaible...
        }
    }
    func changePhotoAction()
    {
        
                let alertController = UIAlertController(title: nil, message:
                    nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                    // ...
                }
        
                let photoAction = UIAlertAction(title: "Camera Roll", style: .Default) { (action) in
                    // ...
                    self.takePhoto()
                }
        
                let galleryAction = UIAlertAction(title: "Gallery", style: .Default) { (action) in
                    self.gallery()
                }
        
                alertController.addAction(photoAction)
                alertController.addAction(galleryAction)
                alertController.addAction(cancelAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
    }
    func keyboardWillChangeFrame(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
            scrollBottom.constant = keyboardSize.height
            UIView.animateWithDuration(FBoxConstants.kAnimationDuration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
                self.view.layoutIfNeeded()
                }, completion:{(_) -> Void in
            })
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        scrollBottom.constant = 0.0
        UIView.animateWithDuration(FBoxConstants.kAnimationDuration, delay: 0.0, usingSpringWithDamping: FBoxConstants.kAnimationDamping, initialSpringVelocity: FBoxConstants.kAnimationInitialVelocity, options: .CurveEaseInOut, animations: { () -> Void in
            self.view.layoutIfNeeded()
            }, completion:{(_) -> Void in
                
        })
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func takePhoto()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    func gallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
        imagePicker.allowsEditing = true
        self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
}
extension YourProfileViewController: UIImagePickerControllerDelegate
{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.avatarImg.image = image
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("cancel")
    }
}