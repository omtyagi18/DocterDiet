//
//  CommonFunctions.swift
//  GameMaster
//
//  Created by Akshay Rai on 04/02/16.
//  Copyright © 2016 AppInfy. All rights reserved.
//

import Foundation
import UIKit

enum UIUserInterfaceIdiom : Int
{
    case unspecified
    case phone
    case pad
}

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
}

class CommonFunctions
{
    
    
    class func validateName(name: String!) -> Bool
    {
        if name.stringByRemovingLeadingTrailingWhitespaces().length > 0
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    class func validateEmail(emailAddress: String!) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        if !emailTest.evaluate(with: emailAddress)
        {
            return false
        }
        else if emailAddress.characters.count == 0
        {
            return false
        }
        else
        {
            return true
        }
    }
    
    class func validatePassword(password: String!) -> Bool
    {
        
        if password.characters.count <= 4
        {
            return false
        }
        else
        {
            return true
        }
    }
   
    class func validatePhone(_ phone : String!) -> Bool
    {
        if phone.characters.count >= 10
        {
            if phone == "0000000000"{
                return false
            }
            return true
        }
        else
        {
            return false
        }
    }


        
    
    class func getIntValue(_ value:AnyObject?) -> Int? {
        if let v = value {
            let intValueStr = "\(v)"
            return Int(intValueStr)
        }
        return nil
    }
    
    //MARK:- delay Function
    class func delay(_ delay:Double, closure:@escaping ()->()) {
        
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
            execute: closure
        )
    }
    
    //MARK:- Image Processing 
    
    class func fixOrientationforImage(_ image: UIImage) -> UIImage {
        
        if image.imageOrientation == UIImageOrientation.up {
            return image
        }
        var transform: CGAffineTransform = CGAffineTransform.identity
        switch image.imageOrientation {
        case .up,.downMirrored:
            transform = transform.translatedBy(x: image.size.width, y: image.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        case .left,.leftMirrored:
            transform = transform.translatedBy(x: image.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi/2))
        case .right,.rightMirrored:
            transform = transform.translatedBy(x: 0, y: image.size.height)
            transform = transform.rotated(by: CGFloat(-Double.pi/2))
        default:
            print("")
        }
        switch image.imageOrientation {
        case .upMirrored,.downMirrored:
            transform = transform.translatedBy(x: image.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored,.rightMirrored:
            transform = transform.translatedBy(x: image.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            print("")
        }
        let ctx: CGContext = CGContext(data: nil, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: image.cgImage!.bitsPerComponent, bytesPerRow: 0, space: image.cgImage!.colorSpace!, bitmapInfo: image.cgImage!.bitmapInfo.rawValue)!
        ctx.concatenate(transform)
        switch image.imageOrientation {
        case .left,.leftMirrored,.right,.rightMirrored:
            ctx.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: image.size.height, height: image.size.width))
        default:
            ctx.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        }
        let cgimg: CGImage = ctx.makeImage()!
        let img: UIImage = UIImage(cgImage: cgimg)
        return img
    }
    
    func errorMessage(error: NSError) -> String{
        
        if error.code == -101{
            return "Network Error"
        }else{
            return "Server Error"
        }
    }
    
    class func resizeImage(_ size: CGSize, image: UIImage) -> UIImage{
        let rect = CGRect(x: 0,y: 0,width: size.width,height: size.height);
        UIGraphicsBeginImageContext(rect.size);
        image.draw(in: rect)
        let picture1 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return picture1!
    }

    class func getStringFromTimeinterval(_ interval: Int) -> String {
        var str: String
        if interval > 60 * 60 * 24 * 3 {
            str = "few days ago"
        }
        else if interval > 60 * 60 * 24 * 2 {
            str = "2 days ago"
        }
        else if interval > 60 * 60 * 24 {
            str = "1 day ago"
        }
        else if interval > 60 * 60 {
            let a: Int = interval / (60 * 60)
            if a > 1 {
                str = "\(a) hours ago"
            }
            else {
                str = "1 hour ago"
            }
        }
        else if interval > 60 {
            let a: Int = interval / 60
            if a > 1 {
                str = "\(a) mins ago"
            }
            else {
                str = "1 min ago"
            }
        }
        else {
            str = "\(interval) secs ago"
        }
        
        return str
    }
    
    func offsetFrom(_ date:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date2 : Date = Date() //initialized by default with the current date
        let strTodadate=formatter.string(from: date2)
        let datetoday: Date=formatter.date(from: strTodadate)!
        
        
        let dayHourMinuteSecond: NSCalendar.Unit = [.day, .hour, .minute, .second]
        let difference = (Calendar.current as NSCalendar).components(dayHourMinuteSecond, from: date, to: datetoday, options: [])
        
        let seconds = "\(String(describing: difference.second))s"
        let minutes = "\(String(describing: difference.minute))m" + " " + seconds
        let hours = "\(String(describing: difference.hour))h" + " " + minutes
        let days = "\(String(describing: difference.day))d" + " " + hours
        
        if difference.day!    > 0 { return days }
        if difference.hour!   > 0 { return hours }
        if difference.minute! > 0 { return minutes }
        if difference.second! > 0 { return seconds }
        return ""
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
class Utility: NSObject {
    class func showAlertOnViewController(
        targetVC: UIViewController,
        title: String,
        message: String)
    {
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert)
        let okButton = UIAlertAction(
            title:"OK",
            style: UIAlertActionStyle.default,
            handler:
            {
                (alert: UIAlertAction!)  in
        })
        alert.addAction(okButton)
        targetVC.present(alert, animated: true, completion: nil)
    }
}

