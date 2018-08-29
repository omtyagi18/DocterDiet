
//  ServiceClass.swift
//  Floyd
//



import Foundation
import SystemConfiguration
import AFNetworking
let NO_INTERNET_MSG = "No Internet Connection Found"
let NO_INTERNET_ERROR_CODE = -100
let PARSING_ERROR_CODE = -101
let TimeOutInterval : TimeInterval = 30.0

public final class ServiceClass
{
    class var isConnectedToNetwork : Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    
    internal typealias webServiceSuccess = (_ JSON : [String : AnyObject]) -> Void
    internal typealias webServiceFailure = (_ error : NSError) -> Void
    
    class func POST(_ URLString: String!, parameters: AnyObject!, successBlock: @escaping webServiceSuccess , failureBlock: @escaping webServiceFailure){
        
        if !ServiceClass.isConnectedToNetwork{
            failureBlock(NSError.networkConnectionError(urlString: URLString))
            return
        }
        let manager = AFHTTPSessionManager(baseURL: URL(string: BaseURL))
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer.timeoutInterval = TimeOutInterval
        manager.requestSerializer.setValue("Application/json", forHTTPHeaderField: "Accept")

        //   [singelton.requestSerializer setValue:userDeviceId forHTTPHeaderField:@"userDeviceId"];
        
//        manager.requestSerializer.setValue("mys3cr3tk3y", forHTTPHeaderField: "Accesstoken")
//        let Session = UserDefaults.standard.object(forKey: "session_id") as? String
//        manager.requestSerializer.setValue(Session, forHTTPHeaderField: "Sessionid")

        
        manager.post(URLString, parameters: parameters, progress: nil, success: { (task, responseObject) -> Void in
            let decodedStr = NSString(data: (responseObject as! Data), encoding: 4)
            print(decodedStr ?? "")
            do{
                let jsonObject =  try JSONSerialization.jsonObject(with: responseObject as! Data, options: JSONSerialization.ReadingOptions.mutableContainers)
                if let jsonDict = jsonObject as? [String: AnyObject]
                {
                    successBlock(jsonDict)
                }
                else
                {
                    failureBlock(NSError.jsonParsingError(urlString: URLString))
                }
                
            }catch{
                failureBlock(NSError.jsonParsingError(urlString: URLString))
            }
        })
        { (task, error)  in
            print(error)
            failureBlock(error as NSError)
        }
    }
    
    class func POSTWithTokken(_ URLString: String!, parameters: AnyObject!, successBlock: @escaping webServiceSuccess , failureBlock: @escaping webServiceFailure){
        
        if !ServiceClass.isConnectedToNetwork{
            failureBlock(NSError.networkConnectionError(urlString: URLString))
            return
        }
        let manager = AFHTTPSessionManager(baseURL: URL(string: BaseURL))
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer.timeoutInterval = TimeOutInterval
          manager.requestSerializer.setValue("Application/json", forHTTPHeaderField: "Accept")
                let Session = UserDefaults.standard.object(forKey: authorizationKey) as? String
                manager.requestSerializer.setValue(Session, forHTTPHeaderField: "Authorization")
        
        
        manager.post(URLString, parameters: parameters, progress: nil, success: { (task, responseObject) -> Void in
            let decodedStr = NSString(data: (responseObject as! Data), encoding: 4)
            print(decodedStr ?? "")
            do{
                let jsonObject =  try JSONSerialization.jsonObject(with: responseObject as! Data, options: JSONSerialization.ReadingOptions.mutableContainers)
                if let jsonDict = jsonObject as? [String: AnyObject]
                {
                    successBlock(jsonDict)
                }
                else
                {
                    failureBlock(NSError.jsonParsingError(urlString: URLString))
                }
                
            }catch{
                failureBlock(NSError.jsonParsingError(urlString: URLString))
            }
        })
        { (task, error)  in
            print(error)
            failureBlock(error as NSError)
        }
    }
    class func GET(_ URLString: String!, parameters: AnyObject!, successBlock: @escaping webServiceSuccess , failureBlock: @escaping webServiceFailure){
        
        if !ServiceClass.isConnectedToNetwork{
            failureBlock(NSError.networkConnectionError(urlString: URLString))
            return
        }
        let manager = AFHTTPSessionManager(baseURL: URL(string: BaseURL))
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer.timeoutInterval = TimeOutInterval

        manager.get(URLString, parameters: parameters, progress: nil, success: { (task, responseObject) in
            let decodedStr = NSString(data: (responseObject as! Data), encoding: 4)
            print(decodedStr ?? "")
            do{
                let jsonObject =  try JSONSerialization.jsonObject(with: responseObject as! Data, options: JSONSerialization.ReadingOptions.mutableContainers)
                if let jsonDict = jsonObject as? [String: AnyObject]
                {
                    successBlock(jsonDict)
                }
                    
                else
                {
                    failureBlock(NSError.jsonParsingError(urlString: URLString))
                }
                
            }catch{
                failureBlock(NSError.jsonParsingError(urlString: URLString))
            }
            
            
        }) { (task, error) in
            print(error)
            failureBlock(error as NSError)
            
        }
    }
    
    
    class func POSTWithImage(_ URLString: String!, parameters: AnyObject!, imagedata: Data?, imageKey: String!, successBlock: @escaping webServiceSuccess , failureBlock: @escaping webServiceFailure)
    {
        
        if !ServiceClass.isConnectedToNetwork
        {
            failureBlock(NSError.networkConnectionError(urlString: URLString))
            return
        }
        let manager = AFHTTPSessionManager(baseURL: URL(string: BaseURL))
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer.timeoutInterval = TimeOutInterval
        manager.requestSerializer.setValue("mys3cr3tk3y", forHTTPHeaderField: "Accesstoken")
        let Session = UserDefaults.standard.object(forKey: "session_id") as? String
        manager.requestSerializer.setValue(Session, forHTTPHeaderField: "Sessionid")

        
        manager.post(URLString, parameters: parameters, constructingBodyWith: { (multipartFormData: AFMultipartFormData!) -> Void in
            if imagedata != nil {
                multipartFormData.appendPart(withFileData: imagedata!, name: imageKey, fileName:"img.jpg", mimeType:"image/jpeg")
                
            }
        }, progress: { (progress) -> Void in
                        DispatchQueue.main.async {
//                            KVNProgress.show(CGFloat(progress.fractionCompleted), status: "Uploading Pic...\(String(format: "%.01f", progress.fractionCompleted*100))%")
                        }
        }, success: { (task, result) -> Void in
            
            let decodedStr = NSString(data: (result as! Data), encoding: 4)
            print(decodedStr ?? "no value")
            
            do{
                let jsonObject =  try JSONSerialization.jsonObject(with: result as! Data, options: JSONSerialization.ReadingOptions.mutableContainers)
                if let jsonDict = jsonObject as? [String: AnyObject]
                {
                    successBlock(jsonDict)
                }
                else
                {
                    failureBlock(NSError.jsonParsingError(urlString: URLString))
                }
                
            }catch{
                failureBlock(NSError.jsonParsingError(urlString: URLString))
            }
            
        }){ (task, error) in
            print(error)
            failureBlock(error as NSError)
        }
    }
    class func POSTWithTwoImageS(_ URLString: String!, parameters: AnyObject!, image1data: Data?,image2data: Data?, image1Key: String!,image2Key: String!, successBlock: @escaping webServiceSuccess , failureBlock: @escaping webServiceFailure)
    {
        
        if !ServiceClass.isConnectedToNetwork
        {
            failureBlock(NSError.networkConnectionError(urlString: URLString))
            return
        }
        let manager = AFHTTPSessionManager(baseURL: URL(string: BaseURL))
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer.timeoutInterval = TimeOutInterval
        manager.requestSerializer.setValue("mys3cr3tk3y", forHTTPHeaderField: "Accesstoken")
        let Session = UserDefaults.standard.object(forKey: "session_id") as? String
        manager.requestSerializer.setValue(Session, forHTTPHeaderField: "Sesssionid")

        
        manager.post(URLString, parameters: parameters, constructingBodyWith: { (multipartFormData: AFMultipartFormData!) -> Void in
            if image1data != nil {
                multipartFormData.appendPart(withFileData: image1data!, name: image1Key, fileName:"profile.jpg", mimeType:"image/jpeg")
                
            }
            if image2data != nil {
                multipartFormData.appendPart(withFileData: image2data!, name: image2Key, fileName:"cover.jpg", mimeType:"image/jpeg")
            }
        }, progress: { (progress) -> Void in
            
        }, success: { (task, result) -> Void in
            //let decodedStr = NSString(data: (result as! NSData), encoding: 4)
            
            do{
                let jsonObject =  try JSONSerialization.jsonObject(with: result as! Data, options: JSONSerialization.ReadingOptions.mutableContainers)
                if let jsonDict = jsonObject as? [String: AnyObject]
                {
                    successBlock(jsonDict)
                }
                else
                {
                    
                    failureBlock(NSError.jsonParsingError(urlString: URLString))
                }
                
            }catch{
                failureBlock(NSError.jsonParsingError(urlString: URLString))
            }
            
        })
        { (task, error) in
            failureBlock(error as NSError)
        }
    }
    
}

