//
//  ViewController.swift
//  DietPlan
//
//  Created by Ankit Tyagi on 28/08/18.
//  Copyright © 2018 Ankit Tyagi. All rights reserved.
//

import UIKit
import UserNotifications
import KVNProgress
class ViewController: UIViewController {
    
// MARK: IBOutlet and local Variable
    @IBOutlet weak var Diet_Table: UITableView!
    @IBOutlet weak var Duration_label: UILabel!
    

    struct Objects {
        var sectionName : String!
        var sectionObjects : [[String:AnyObject]]!
    }
    var objectArray = [Objects]()
    
// MARK: View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.Diet_Table.tableFooterView = UIView()
        self.Get_Diet_Plan_Service()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
// MARK: Get Diet-Plan From Server

    func Get_Diet_Plan_Service(){
        let Dict = [String : AnyObject]()
        KVNProgress.show(withStatus: "Loading!")
        UserService.DietPlanService(Dict, completionBlock: { (success,
            errorMessage, data) -> Void in
            KVNProgress.dismiss()
            if success{
                if let dictionary = data{
                    if let week_diet_data = dictionary["week_diet_data"] as? [String : Any]{
                        for (key, value) in week_diet_data {
                            self.objectArray.append(Objects(sectionName: key, sectionObjects: value as! [[String : AnyObject]]))
                        }
                    }
                    if let diet_duration = dictionary["diet_duration"] as? Int{
                        self.Duration_label.text = "Diet Duration : \(diet_duration) days"
                        self.AddNotificationForDietPlan(Duration: diet_duration)
                    }
                    DispatchQueue.main.async {
                        self.view.layoutIfNeeded()
                        self.Diet_Table.reloadData()
                    }
                }
            }else{
                let alert = UIAlertController(title: AppName, message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
                let action =  UIAlertAction(title: AlertOk, style: UIAlertActionStyle.destructive, handler: { (action) -> Void in
                })
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        })
        
    }
    
// MARK: TableView PlaceHolder

    func EmptyMessage(message:String) {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        messageLabel.text = message
        messageLabel.textColor = UIColor.black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 20)
        messageLabel.sizeToFit()
        
        self.Diet_Table.backgroundView = messageLabel;
    }
    
// MARK: Find Date to Notify and Schedule local Notification
    
    //Find Date to add Notification
    func AddNotificationForDietPlan(Duration: Int){
        //Remove prrivious Diet Notification
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        //Find Date to add Notification
        let startDate = Date()
        for i in 0 ... Duration{
          let TargetDate = startDate.add(years: 0, months: 0, days: i, hours: 0, minutes: 0, seconds: 0)
            let dayname = TargetDate.dayOfWeek() as? String
             for item in self.objectArray{
                if dayname == item.sectionName.capitalized{
                    for SpecificTimeInDay in item.sectionObjects{
                        let timeSlot = SpecificTimeInDay["meal_time"] as? String
                        let Body = SpecificTimeInDay["food"] as? String
                        let TimeArray = timeSlot?.components(separatedBy: ":")
                        let Hours    = Int(TimeArray![0])
                        let Mins =  Int(TimeArray![1])
                        let calendar = Calendar(identifier: .gregorian)
                        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: TargetDate)
                        components.hour = Hours
                        components.minute = Mins
                        let dateForNotification =  calendar.date(from: components)
                        
                        //Reduce 5 min from  Diet-time
                        let reducedTime = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)?.date(byAdding: .minute, value: -5, to: dateForNotification!, options: NSCalendar.Options())
                        //call schedule notification function
                        
                         self.scheduleNotification(at: reducedTime!, body: Body!, titles: "Diet Reminder")
                    }
                }
            }
        }
    }
    
    //Schedule New Notification .
    func scheduleNotification(at date: Date, body: String, titles:String) {
        
        let trig1 = Calendar.current.dateComponents([.year,.month,.day,.hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: trig1, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = titles
        content.subtitle = body
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "DietList"
        
        let request = UNNotificationRequest(identifier: "textNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                print("Uh oh! We had an error: \(error)")
            }
        }
    }

}

// MARK: TableView Datasource and Delegate

extension ViewController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if objectArray.count > 0 {
            return objectArray.count
        } else {
            self.Duration_label.text = "You don't have any Diet Plan yet.\n Please Try Again"
            self.Duration_label.textAlignment = .center
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectArray[section].sectionObjects.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return objectArray[section].sectionName.capitalized
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Diet_Table.dequeueReusableCell(withIdentifier: "DietTableCell") as! DietTableCell
        let Dict = objectArray[indexPath.section].sectionObjects[indexPath.row] as [String:Any]
        cell.Food_label.text = Dict["food"] as? String
        cell.Time_label.text = Dict["meal_time"] as? String
        return cell
    }
}

// MARK: TableViewCell for Diet Table

class DietTableCell : UITableViewCell{
    @IBOutlet weak var Food_label: UILabel!
    @IBOutlet weak var Time_label: UILabel!
}


