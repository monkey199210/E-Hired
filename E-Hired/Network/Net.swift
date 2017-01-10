//
//  Net.swift
//  AcroYoga
//
//  Created by Rui Caneira on 9/10/16.
//  Copyright © 2016 ku. All rights reserved.
//

import Foundation
import BrightFutures
import SwiftyJSON

class Net {

    class func requestServer(urlString: String, params: [String: AnyObject]) -> Future<Bool, NSError>
    {
        let promise = Promise<Bool, NSError>()
        //        let userDefaults = NSUserDefaults.standardUserDefaults()
        //        let username = userDefaults.objectForKey("username")
        //        let userID = userDefaults.objectForKey("userid")
        //        let mainImageUrl = userDefaults.objectForKey("userImage")
        let url = getRealUrl(urlString)
        Webservice.request(url, params: params, animated: true).onSuccess { (result: WebResult<EHResult>) -> Void in
            if result.value?.status == "ok" {
                promise.success(true)
            }else{
                let error = NSError(domain: result.value!.error, code: 1, userInfo: nil)
                promise.failure(error)
            }
            }.onFailure { (error) -> Void in
                print("Error: \(error)")
                promise.failure(error)
        }
        
        return promise.future
    }
    class func uploadProfileImage(image: UIImage) -> Future<Bool, NSError>
    {
        let promise = Promise<Bool, NSError>()
        let urlString = getRealUrl(EHNet.UPDATE_PROFILE_PRICTURE_URL)
        let imageData = NSData(data: UIImageJPEGRepresentation(image, 1.0)!)
        Webservice.uploadImageData(urlString, imageData: imageData,animated: true).onSuccess { (result: WebResult<EHResult>) -> Void in
            if result.value?.status == "ok" {
                promise.success(true)
            }else{
                let error = NSError(domain: result.value!.error, code: 1, userInfo: nil)
                promise.failure(error)
            }
            }.onFailure { (error) -> Void in
                print("Error: \(error)")
                promise.failure(error)
        }
        
        return promise.future
    }
    class func uploadProfile(params:[String: AnyObject]) -> Future<Bool, NSError>
    {
        
        let promise = Promise<Bool, NSError>()
        let urlString = getRealUrl(EHNet.UPDATE_PROFILE_URL)
        
        Webservice.request(urlString, params: params, animated: true).onSuccess { (result: WebResult<EHResult>) -> Void in
            if result.value?.status == "ok" {
                promise.success(true)
            }else{
                let error = NSError(domain: result.value!.error, code: 1, userInfo: nil)
                promise.failure(error)
            }
            }.onFailure { (error) -> Void in
                print("Error: \(error)")
                promise.failure(error)
        }
        
        return promise.future
    }
    
    
    class func getJobs(date: String?) -> Future<EHJobs, NSError> {
        let promise = Promise<EHJobs, NSError>()
        var urlString = getRealUrl(EHNet.GET_JOBS)
        if date != nil
        {
            let str = "&prev_days="
            urlString = urlString.stringByAppendingString(str)
            urlString = urlString.stringByAppendingString(date!)
        }
        //        Webservice.cancelRequestForKey(kMeRequestKey)
        Webservice.getRequest(urlString, animated: true).onSuccess { (result: WebResult<EHJobs>) -> Void in
            promise.success(result.value!)
            }.onFailure { (error) -> Void in
                print("Error: \(error)")
                promise.failure(error)
        }
        return promise.future
    }
    class func forgotPW(email: String) -> Future<EHResult, NSError> {
        let promise = Promise<EHResult, NSError>()
        let urlString = EHNet.FORGOT_PW + email
        //        Webservice.cancelRequestForKey(kMeRequestKey)
        Webservice.getRequest(urlString, animated: true).onSuccess { (result: WebResult<EHResult>) -> Void in
            promise.success(result.value!)
            }.onFailure { (error) -> Void in
                print("Error: \(error)")
                promise.failure(error)
        }
        return promise.future
    }
    class func checkNewMessage(priority: Int) -> Future<EHResult, NSError> {
        let promise = Promise<EHResult, NSError>()
        let urlString = getRealUrl(EHNet.CHECK_NEW_MESSAGE + String(priority))
        //        Webservice.cancelRequestForKey(kMeRequestKey)
        Webservice.getRequest(urlString, animated: true).onSuccess { (result: WebResult<EHResult>) -> Void in
            promise.success(result.value!)
            }.onFailure { (error) -> Void in
                print("Error: \(error)")
                promise.failure(error)
        }
        return promise.future
    }

    class func getMessages(params: [String: AnyObject]) -> Future<EHMessage, NSError> {
        let promise = Promise<EHMessage, NSError>()
        let urlString = getRealUrl(EHNet.GET_MESSAGE)
        //        Webservice.cancelRequestForKey(kMeRequestKey)
        Webservice.request(urlString, params: params, animated: true).onSuccess { (result: WebResult<EHMessage>) -> Void in
            promise.success(result.value!)
            }.onFailure { (error) -> Void in
                print("Error: \(error)")
                promise.failure(error)
        }
        return promise.future
    }
    
    class func setMessageOpened(params: [String: AnyObject]) -> Future<EHResult, NSError> {
        let promise = Promise<EHResult, NSError>()
        let urlString = getRealUrl(EHNet.SET_MESSAGE_OPENED)
        //        Webservice.cancelRequestForKey(kMeRequestKey)
        Webservice.request(urlString, params: params, animated: true).onSuccess { (result: WebResult<EHResult>) -> Void in
            promise.success(result.value!)
            }.onFailure { (error) -> Void in
                print("Error: \(error)")
                promise.failure(error)
        }
        return promise.future
    }
    class func replyMessage(params: [String: AnyObject]) -> Future<EHResult, NSError> {
        let promise = Promise<EHResult, NSError>()
        let urlString = getRealUrl(EHNet.REPLY_MESSAGE)
        //        Webservice.cancelRequestForKey(kMeRequestKey)
        Webservice.request(urlString, params: params, animated: true).onSuccess { (result: WebResult<EHResult>) -> Void in
            promise.success(result.value!)
            }.onFailure { (error) -> Void in
                print("Error: \(error)")
                promise.failure(error)
        }
        return promise.future
    }
    class func getAutoAPI_Key() -> Future<EHAPIKey, NSError> {
        let promise = Promise<EHAPIKey, NSError>()
        let urlString = EHNet.AUTOKEY_URL
        
        //        Webservice.cancelRequestForKey(kMeRequestKey)
        Webservice.getRequest(urlString, animated: true).onSuccess { (result: WebResult<EHAPIKey>) -> Void in
            promise.success(result.value!)
            }.onFailure { (error) -> Void in
                print("Error: \(error)")
                promise.failure(error)
        }
        return promise.future
    }

    
    class func getAPI_Key(email: String!, password: String!) -> Future<EHAPIKey, NSError> {
        let promise = Promise<EHAPIKey, NSError>()
        var urlString = EHNet.BASE_URL + EHNet.GET_APIKEY
        
        let str = "&email="
        urlString = urlString.stringByAppendingString(str)
        urlString = urlString.stringByAppendingString(email!)
        urlString = urlString.stringByAppendingString("&pwd=")
        urlString = urlString.stringByAppendingString(password)
        //        Webservice.cancelRequestForKey(kMeRequestKey)
        Webservice.getRequest(urlString, animated: true).onSuccess { (result: WebResult<EHAPIKey>) -> Void in
            promise.success(result.value!)
            }.onFailure { (error) -> Void in
                print("Error: \(error)")
                promise.failure(error)
        }
        return promise.future
    }
    class func searchJobs(params: [String: AnyObject]) -> Future<EHJobs, NSError> {
        let promise = Promise<EHJobs, NSError>()
         let urlString = getRealUrl(EHNet.SEARCH_JOBS_URL)
        //        Webservice.cancelRequestForKey(kMeRequestKey)
        Webservice.request(urlString, params: params, animated: true).onSuccess { (result: WebResult<EHJobs>) -> Void in
            promise.success(result.value!)
            }.onFailure { (error) -> Void in
                print("Error: \(error)")
                promise.failure(error)
        }
        return promise.future
    }
    
    class func getProfile() -> Future<EHProfile, NSError> {
        let promise = Promise<EHProfile, NSError>()
        let urlString = getRealUrl(EHNet.GET_PROFILE)
        //        Webservice.cancelRequestForKey(kMeRequestKey)
        Webservice.getRequest(urlString, animated: true).onSuccess { (result: WebResult<EHProfile>) -> Void in
            promise.success(result.value!)
            }.onFailure { (error) -> Void in
                print("Error: \(error)")
                promise.failure(error)
        }
        return promise.future
    }
    class func getRealUrl(action: String!) -> String {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var apiKey = ""
        apiKey = (userDefaults.objectForKey("apikey") as? String)!
        
        let urlString = EHNet.BASE_URL
            + "api-key=" + apiKey + "&"
            + action
        return urlString
    }
    class func getRequestString(param: [EHJobs.Detail]) -> String
    {
        var requestStr = "["
        for i in 0 ..< param.count
        {
            requestStr = requestStr + "{" + EHNet.JOB_VIEW_JOB_SITE + ":" + param[i].job_site + ", " + EHNet.JOB_VIEW_JOB_SITE_ID + ":" + "121" + "}"
            if i != param.count-1
            {
                requestStr = requestStr + ","
            }
        }
        
        requestStr = requestStr + "]"
        return requestStr
    }
    
    
}