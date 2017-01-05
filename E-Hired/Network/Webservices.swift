//
//  Webservices.swift
//  AcroYoga
//
//  Created by Rui Caneira on 9/9/16.
//  Copyright © 2016 ku. All rights reserved.
//

import Foundation
import Alamofire
import MRProgress
import Genome
import BrightFutures
import Async
struct EHNet {
    
    static let  INFO_TO_DETAIL = "goodsinfo_to_detail"
    static let  INFO_TO_MESSAGE = "go to Message"
    static let INFO_TO_CHAT = "go_to_chat"
    
    static let BASE_URL = "http://e-hired.com/mobile.php?"
    static let  GET_JOBS = "action=get_jobs"
    static let  GET_APIKEY = "action=get_api_key"
    static let GET_PROFILE = "action=get_profile"
    static let GET_MESSAGE = "action=get_messages"
    
    static let UPDATE_PROFILE_URL = "action=update_profile"
    static let UPDATE_PROFILE_PRICTURE_URL = "action=update_profile_picture"
    static let SEARCH_JOBS_URL = "action=search_jobs&query=accounting&location=08012"
    
    static let GET_SCHOOL_INFO_URL = "action=get_school_info"
    static let GET_MESSAGES_URL = "action=get_messages"
    static let GET_PROFILE_METADATA_URL = "action=get_profile_metadata"
    
    static let  JOBS_VIEWED_URL = "action=set_jobs_viewed"
    //update profile key
    static let USER_LAST_NAME = "user_last_name"
    static let USER_FIRST_NAME = "user_first_name"
    static let USER_EMAIL = "user_email"
    static let USER_ZIP_CODE = "user_zip_code"
    static let PROFILE_OBJECTIVE = "profile_objective"
    static let PROFILE_INDUSTRY = "profile_industry"
    static let PROFILE_SALARY = "profile_salary"
    static let PROFILE_AVALABILITY = "profile_availability"
    static let PROFILE_EDUCATION = "profile_education"
    static let PROFILE_PICTURE = "profile_picture_file"
    static let SKILL0 = "skill_0"
    static let SKILL1 = "skill_1"
    static let SKILL2 = "skill_2"
    static let SKILL3 = "skill_3"
    static let SKILL4 = "skill_4"
    static let SKILL5 = "skill_5"
    static let SKILL6 = "skill_6"
    static let SKILL7 = "skill_7"
    
    // search key
    static let SEARCH_WHAT =  "query"
    static let SEARCH_LOCATION = "location"
    
    // Job viewed Key
    static let JOB_VIEW_JOB_SITE =  "job_site"
    static let JOB_VIEW_JOB_SITE_ID =  "job_site_id"
    static let JOB_LIST_KEY =  "job_list"
    
    //Job_viewed
    
    
}
class WebResult<T> {
    var value: T?
    var array: Array<T> = []
    init(value: T?, array: Array<T>) {
        self.value = value
        self.array = array
    }
    init(value: T?) {
        self.value = value
    }
}
enum ConvertingError : ErrorType {
    case UnableToConvertJson
    case UnableToConvertJsonParsed
}
class Webservice {
    
    static func toJson(value: AnyObject) throws -> Genome.JSON {
        if let json = value as? Genome.JSON {
            return json
        } else {
            throw ConvertingError.UnableToConvertJson
        }
    }

    
    class func request<T: BasicMappable>(urlString: String, params: [String: AnyObject]?, animated: Bool) -> Future<WebResult<T>, NSError> {
        print(urlString)
        
        let promise = Promise<WebResult<T>, NSError>()
//         showBlocking(animated)
        Alamofire.request(.POST, urlString, parameters: params).responseJSON { (response) -> Void in
            Async.background {
                //let dataString = NSString(data: response.data!, encoding: NSUTF8StringEncoding)
                //print(dataString)
                mapResult(response, promise: promise)
                }.main{
//                    closeBlocking(animated)
            }
        }
        return promise.future
    }
    
    class func getRequest<T: BasicMappable>(urlString: String, animated: Bool) -> Future<WebResult<T>, NSError> {
        print(urlString)
        
        let promise = Promise<WebResult<T>, NSError>()
        //         showBlocking(animated)
        Alamofire.request(.GET, urlString).responseJSON { (response) -> Void in
            Async.background {
                //let dataString = NSString(data: response.data!, encoding: NSUTF8StringEncoding)
                //print(dataString)
                mapResult(response, promise: promise)
                }.main{
                    //                    closeBlocking(animated)
            }
        }
        return promise.future
    }

//    class func upload<T: BasicMappable>(urlString: String, image: NSData, params: [String: AnyObject]?, animated: Bool) -> Future<WebResult<T>, NSError> {
//        print(urlString)
//        
//        let promise = Promise<WebResult<T>, NSError>()
//        let urlRequest = urlRequestWithComponents(urlString, parameters: params, imageData: image)
//        showBlocking(animated)
//        Alamofire.request(.POST, urlString, parameters: params).responseJSON { (response) -> Void in
//            Async.background {
//                //let dataString = NSString(data: response.data!, encoding: NSUTF8StringEncoding)
//                //print(dataString)
//                mapResult(response, promise: promise)
//                }.main{
//                    closeBlocking(animated)
//            }
//        }
//        
//        
//        Alamofire.upload(urlRequest.0, urlRequest.1)
//            .progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
//                println("\(totalBytesWritten) / \(totalBytesExpectedToWrite)")
//            }
//            .responseJSON { (request, response, JSON, error) in
//                println("REQUEST \(request)")
//                println("RESPONSE \(response)")
//                println("JSON \(JSON)")
//                println("ERROR \(error)")
//        }
//        return promise.future
//    }
    class func POST(RequestURL: String,postData:[AnyObject]?,successHandler: (String) -> (),failureHandler: (String) -> ()) -> () {
        
        print("POST : \(RequestURL)")
        
        let request = NSMutableURLRequest(URL: NSURL(string:RequestURL)!)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.HTTPBody  = try NSJSONSerialization.dataWithJSONObject(postData!, options:[])
            
            
        } catch {
            print("JSON serialization failed:  \(error)")
        }
        
        Alamofire.request(request)
            .responseString{ response in
                switch response.result {
                case .Success:
                    print(response.response?.statusCode)
                    print(response.description)
                    if response.response?.statusCode == 200 {
                        successHandler(response.result.value!)
                    }else{
                        failureHandler("\(response.description)")
                    }
                    
                case .Failure(let error):
                    failureHandler("\(error)")
                }
        }
        
    }
    class func uploadImageData<T: BasicMappable>(RequestURL: String,imageData: NSData, animated: Bool) -> Future<WebResult<T>, NSError>  {
        let promise = Promise<WebResult<T>, NSError>()
//        let headerData:[String : String] = ["Content-Type":"application/json"]
        
        Alamofire.upload(.POST, RequestURL, multipartFormData: {
            MultipartFormData in
            
            MultipartFormData.appendBodyPart(data: imageData, name: EHNet.PROFILE_PICTURE, fileName: "myPhoto.png", mimeType: "image/png")
        },
        encodingMemoryThreshold: Manager.MultipartFormDataEncodingMemoryThreshold,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        Async.background {
                            //let dataString = NSString(data: response.data!, encoding: NSUTF8StringEncoding)
                            //print(dataString)
                            mapResult(response, promise: promise)
                            }.main{
                                //                    closeBlocking(animated)
                        }
                    }
                case .Failure(let error):
                    handleError(error)
                    promise.failure(NSError(domain: "UnableToConvertJson", code: -1, userInfo: nil))}
            })
//        Alamofire.upload(.POST, imageShackUrl, multipartFormData: { MultipartFormData in
//            
//            MultipartFormData.appendBodyPart(data: keyData, name: "key")
//            MultipartFormData.appendBodyPart(data: imgData, name: "fileupload", fileName: "image", mimeType: "image/jpg")
//            MultipartFormData.appendBodyPart(data: keyJson, name: "format")
//            
//            },encodingCompletion: { encodingResult in
//                
//                switch encodingResult {
//                    
//                case .Success(let upload, _, _):
//                    
//                    upload.responseJSON { response in
//                        
//                        if let info = response.result.value as? Dictionary<String, AnyObject> {
//                            
//                            if let links = info["links"] as? Dictionary<String, AnyObject> {
//                                
//                                if let imgLink = links["image_link"] as? String {
//                                    print("LINK: \(imgLink)")
//                                }
//                            }
//                        }
//                        
//                    } case .Failure(let error):
//                        print(error)
//                }
//        })
    
        return promise.future
    }
    private class func mapResult<T: BasicMappable>(response: Response<AnyObject, NSError>, promise: Promise<WebResult<T>, NSError>) {
        switch response.result {
        case .Success(let value):
            Async.background {
                do {
                    if let array = value as? NSArray {
                        var resultArray: Array<T> = []
                        for arrayValue in array {
                            let json = try toJson(arrayValue)
                            let resultObject = try T.mappedInstance(json)
                            resultArray.append(resultObject)
                        }
                        Async.main {
                            promise.success(WebResult(value: nil, array: resultArray))
                        }
                    }else{
                        let json = try toJson(value)
                        let resultObject = try T.mappedInstance(json)
                        Async.main {
                            promise.success(WebResult(value: resultObject))
                        }
                    }
                } catch {
                    handleError(error)
                    Async.main {
                        promise.failure(NSError(domain: "UnableToConvertJson", code: -1, userInfo: nil))
                    }
                }
            }
        case .Failure(let error):
            handleError(error)
            promise.failure(error)
        }
    }
    class func handleError(error: ErrorType) {
        print(error)
    }
    // MARK: - progress HUD
    private static var isBlocked = false
    private static var blockCount: Int = 0 {
        didSet {
            if !isBlocked && blockCount > 0 {
                isBlocked = true
                MRProgressOverlayView.showOverlayAddedTo(FBoxHelper.getWindow(), title: "", mode: .Indeterminate, animated: true)
            }else if isBlocked && blockCount == 0 {
                isBlocked = false
                MRProgressOverlayView.dismissOverlayForView(FBoxHelper.getWindow(), animated: true)
            }
        }
    }
    class func showBlocking(animated: Bool) {
        if animated {
            self.blockCount += 1
        }
    }
    class func closeBlocking(animated: Bool) {
        if animated {
            self.blockCount -= 1
            if self.blockCount < 0 {
                print("blockCount < 0")
                self.blockCount = 0
            }
        }
    }
    private static var requestsForKey: [String: Request] = [:]
    class func cancelRequestForKey(key: String) {
        if let request = requestsForKey[key] {
            request.cancel()
            requestsForKey.removeValueForKey(key)
        }
    }
    func urlRequestWithComponents(urlString:String, parameters:Dictionary<String, String>, imageData:NSData) -> (URLRequestConvertible, NSData) {
        
        // create url request to send
        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        mutableURLRequest.HTTPMethod = Alamofire.Method.POST.rawValue
        let boundaryConstant = "myRandomBoundary12345";
        let contentType = "multipart/form-data;boundary="+boundaryConstant
        mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        
        
        // create upload data to send
        let uploadData = NSMutableData()
        
        // add image
        uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData("Content-Disposition: form-data; name=\"file\"; filename=\"file.png\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData("Content-Type: image/png\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData(imageData)
        
        // add parameters
        for (key, value) in parameters {
            uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            uploadData.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".dataUsingEncoding(NSUTF8StringEncoding)!)
        }
        uploadData.appendData("\r\n--\(boundaryConstant)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        
        
        // return URLRequestConvertible and NSData
        return (Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0, uploadData)
    }

}
//extension String {
//    static func FBURL(urlString: String) -> String {
//        let localeCode = getLocaleCode();
//        var urlDomain = "com";
//        if(localeCode == "de" || localeCode == "es"){
//            urlDomain = localeCode;
//        }
//        let url = (NSString(format: FBNet.API_BASE_URL, urlDomain) as String)  + urlString;
//        return url;
//    }
//    static func getLocaleCode()->String{
//        let locale = NSLocale.preferredLanguages()[0] as String;
//        return locale.substringToIndex(locale.startIndex.advancedBy(2));
//    }
//}
