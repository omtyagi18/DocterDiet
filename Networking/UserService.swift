
// //
////  UserService.swift
////  GameMaster
////
////  Created by Akshay Rai on 04/02/16.
////  Copyright © 2016 AppInfy. All rights reserved.
//
import UIKit

class UserService {
    
    internal typealias completionClosure = (_ success : Bool, _ errorMessage: String?, _ data: [String: AnyObject]?) -> Void
    
    class func DietPlanService(_ params:[String:AnyObject],completionBlock:@escaping completionClosure){
        ServiceClass.GET(GetDiet, parameters: params as AnyObject, successBlock: { (JSON) -> Void in
            if let errorCode = JSON["status"] as? Bool, errorCode != true{
                completionBlock(false, JSON as? String, nil)
            }else{
                completionBlock(true, nil,JSON as! [String : AnyObject])
            }
        }) { (error) -> Void in
            completionBlock(false, error.localizedDescription, nil)
        }
    }
    
}
