//
//  Extensions.swift
//  GameMaster
//
//  Created by Akshay Rai on 04/02/16.
//  Copyright © 2016 AppInfy. All rights reserved.
//
//
import Foundation
import UIKit

extension Date {
    
    /// Returns a Date with the specified days added to the one it is called with
    func add(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date {
        var targetDay: Date
        targetDay = Calendar.current.date(byAdding: .year, value: years, to: self)!
        targetDay = Calendar.current.date(byAdding: .month, value: months, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .day, value: days, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .hour, value: hours, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .minute, value: minutes, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .second, value: seconds, to: targetDay)!
        return targetDay
    }
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
}
//MARK: Stiring Extension
extension String{
    

    var length: Int{
        return self.characters.count
    }
    var localizedString: String{
        return NSLocalizedString(self, comment: "")
    }
    
    func stringByRemovingLeadingTrailingWhitespaces() -> String {
        let spaceSet = CharacterSet.whitespaces
        return self.trimmingCharacters(in: spaceSet)
    }
}

//MARK: UserDefault Extension
extension UserDefaults {
    
    class func save(_ value:AnyObject,forKey key:String)
    {
        UserDefaults.standard.set(value, forKey:key)
        UserDefaults.standard.synchronize()
    }
    
    class func getStringDataFromUserDefault(_ key:String) -> String?
    {
        if let value = UserDefaults.standard.object(forKey: key) as? String {
            return value
        }
        return nil
    }
    class func getAnyDataFromUserDefault(_ key:String) -> AnyObject?
    {
        if let value: AnyObject = UserDefaults.standard.object(forKey: key) as AnyObject? {
            
            return value
        }
        return nil
    }
    class func removeFromUserDefaultForKey(_ key:String)
    {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    class func clean()
    {
        let appDomain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
        UserDefaults.standard.synchronize()
    }
}



extension NSError{
    
    class func networkConnectionError(urlString: String) -> NSError{
        let errorUserInfo =
            [   NSLocalizedDescriptionKey : NO_INTERNET_MSG,
                NSURLErrorFailingURLErrorKey : "\(urlString)"
        ]
        return NSError(domain: NSCocoaErrorDomain, code: NO_INTERNET_ERROR_CODE, userInfo:errorUserInfo)
    }
    
    class func jsonParsingError(urlString: String) -> NSError{
        let errorUserInfo =
            [   NSLocalizedDescriptionKey : "Error In Parsing JSON",
                NSURLErrorFailingURLErrorKey : "\(urlString)"
        ]
        return NSError(domain: NSCocoaErrorDomain, code: PARSING_ERROR_CODE, userInfo:errorUserInfo)
    }
}


