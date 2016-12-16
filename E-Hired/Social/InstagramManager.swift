//
//  File.swift
//  E-Hired
//
//  Created by Rui Caneira on 12/15/16.
//  Copyright © 2016 Rui Caneira. All rights reserved.
//

import UIKit
import Foundation

class InstagramManager: NSObject, UIDocumentInteractionControllerDelegate {
    
    private let kInstagramURL = "instagram://app"
    private let kUTI = "com.instagram.exclusivegram"
    private let kfileNameExtension = "instagram.igo"
    private let kAlertViewTitle = "Error"
    private let kAlertViewMessage = "Please install the Instagram application"
    
    var documentInteractionController = UIDocumentInteractionController()
    
    // singleton manager
    class var sharedManager: InstagramManager {
        struct Singleton {
            static let instance = InstagramManager()
        }
        return Singleton.instance
    }
    
    func postImageToInstagramWithCaption(imageInstagram: UIImage, instagramCaption: String, view: UIView) {
        // called to post image with caption to the instagram application
        
        let instagramURL = NSURL(string: kInstagramURL)
        if UIApplication.sharedApplication().canOpenURL(instagramURL!) {
            let jpgPath = (NSTemporaryDirectory() as NSString).stringByAppendingPathComponent(kfileNameExtension)
            UIImageJPEGRepresentation(imageInstagram, 1.0)!.writeToFile(jpgPath, atomically: true)
            let rect = CGRectMake(0,0,612,612)
            let fileURL = NSURL.fileURLWithPath(jpgPath)
            documentInteractionController.URL = fileURL
            documentInteractionController.delegate = self
            documentInteractionController.UTI = kUTI
            
            // adding caption for the image
            documentInteractionController.annotation = ["InstagramCaption": instagramCaption]
            documentInteractionController.presentOpenInMenuFromRect(rect, inView: view, animated: true)
        } else {
            
            // alert displayed when the instagram application is not available in the device
            UIAlertView(title: kAlertViewTitle, message: kAlertViewMessage, delegate:nil, cancelButtonTitle:"Ok").show()
        }
    }
    
}
