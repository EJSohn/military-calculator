//
//  MainTabViewController.swift
//  military calculator
//
//  Created by ABC on 2016. 3. 30..
//  Copyright © 2016년 ABC. All rights reserved.
//

import UIKit

class MainTabViewController: UIViewController {
    
    @IBOutlet var enterDay: UILabel!
    @IBOutlet var globalDay: UILabel!
    @IBOutlet var fullTime: UILabel!
    @IBOutlet var spendTime: UILabel!
    @IBOutlet var remainTime: UILabel!
    @IBOutlet var status: UILabel!
    @IBOutlet var coupleName: UILabel!
    
    var databasePath = NSString()
    
    let timerFormat = NSDateFormatter()
    let cal = NSCalendar(calendarIdentifier:NSCalendarIdentifierGregorian)!
    var gDayDate = NSDate()
    var timerEnterday = String()


    override func viewDidLoad() {
        if NSUserDefaults.standardUserDefaults().boolForKey("testfirstlaunch"){
            print("not first")
        } else {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.switchViewControllers()
        }

        // Do any additional setup after loading the view.
        
        // create file manager
        let filemgr = NSFileManager.defaultManager()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        let docsDir = dirPaths[0] as NSString
        databasePath = docsDir.stringByAppendingPathComponent("militaryCal.db")
        print("main view database path:"+(databasePath as String))
        
        // check if user didn't make setting
        if !filemgr.fileExistsAtPath(databasePath as String) {
            // lead user to make a setting
            status.text = "아직 세팅을 하지 않으셨습니다."
            
        } else {
            // show calculater to user
            
            status.text = ""
            let milicalDB = FMDatabase(path: databasePath as String)
            let format = NSDateFormatter()
            format.locale = NSLocale(localeIdentifier: "ko_kr")
            format.timeZone = NSTimeZone(name: "kST")
            format.dateFormat = ("yyyy'년' MM'월' dd'일'")
            
            timerFormat.locale = NSLocale(localeIdentifier: "ko_kr")
            timerFormat.timeZone = NSTimeZone(name: "kST")
            timerFormat.dateFormat = ("yyyy'년' MM'월' dd'일' HH:mm:ss.SSS")
            
            
            var someday = NSDate()
            
            if milicalDB.open(){
                let querySQL = "SELECT enterday, gname, bname FROM USER WHERE id = 1"
                let results:FMResultSet? = milicalDB.executeQuery(querySQL , withArgumentsInArray: nil)
                
                if results?.next() == true {
                    // load data from db
                    let enterday = results?.stringForColumn("enterday")
                    timerEnterday = enterday! + " 00:00:00.000"
                    print("timerEnterday :" + timerEnterday)
                    
                    // 이름 띄우기
                    let gbname = "곰신 "+(results?.stringForColumn("gname"))!+" 군화 "+(results?.stringForColumn("bname"))!
                    
                    coupleName.text = gbname
                    // 입대일 설정
                    enterDay.text = enterday
                    
                    // 전역일 설정
                    someday = format.dateFromString(enterday!)!
                    let gDay = format.stringFromDate(NSDate(timeInterval: 730*24*60*60, sinceDate: someday))
                    globalDay.text = gDay
                    
                    gDayDate = timerFormat.dateFromString(gDay+" 00:00:00.000")!
                    // 총복무 설정
                    fullTime.text = "730일"
                    
                    
                    self.timeCalculate()
                    
                    self.startTimer()
                    
                } else {
                    print("Error: database exist but record not found")
                }
            }
        }
        
    }
    
    func timeCalculate() {
        
        // 현재복무 설정
        let now = NSDate()
        let ED = timerFormat.dateFromString(timerEnterday)
        let calculate = cal.components([.Day, .Month, .Year, .Hour, .Minute, .Second, .Nanosecond], fromDate: ED!, toDate:now, options:[])
        
        spendTime.text = "\(calculate.year)년 \(calculate.month)개월 \(calculate.day)일 \(calculate.hour)시간 \(calculate.minute)분 \(calculate.second).\(Int(round(Double(calculate.nanosecond/10000))))초"
        
        
        // 남은복무 설정
        let secondCalculate = cal.components([.Day, .Month, .Year, .Hour, .Minute, .Second], fromDate: now, toDate:gDayDate, options:[])
        
        if secondCalculate.year != 0 {
        remainTime.text = "\(secondCalculate.year)년 \(secondCalculate.month)개월 \(secondCalculate.day)일 \(secondCalculate.hour)시간 \(secondCalculate.minute)분 \(secondCalculate.second)초"
        } else {
        remainTime.text = "\(secondCalculate.month)개월 \(secondCalculate.day)일 \(secondCalculate.hour)시간 \(secondCalculate.minute)분 \(secondCalculate.second)초"
        }
        
    }
    
    func startTimer(){
        let timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("timeCalculate"), userInfo: nil, repeats: true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        viewDidLoad()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
