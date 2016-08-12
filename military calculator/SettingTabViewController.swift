//
//  SettingTabViewController.swift
//  military calculator
//
//  Created by ABC on 2016. 3. 30..
//  Copyright © 2016년 ABC. All rights reserved.
//

import UIKit

class SettingTabViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet var gomName: UITextField!
    @IBOutlet var gunName: UITextField!
    @IBOutlet var status: UILabel!
    
    
    var databasePath = NSString()
    
    @IBOutlet var myPicker: UIPickerView!
    let pickerData = [["2016년", "2015년", "2014년", "2013년", "2012년"],["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"], ["1일", "2일", "3일" ,"4일","5일","6일","7일","8일","9일","10일","11일","12일","13일","14일","15일","16일","17일","18일","19일","20일","21일","22일","23일","24일","25일","26일","27일","28일","29일","30일","31일"]]
    
    var year = String()
    var month = String()
    var day = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myPicker.dataSource = self
        myPicker.delegate = self

        // Do any additional setup after loading the view.
        
        // if database is not at the path
        let filemgr = NSFileManager.defaultManager()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        let docsDir = dirPaths[0] as NSString
        
        databasePath = docsDir.stringByAppendingPathComponent("militaryCal.db")
        print("database path:"+(databasePath as String))
        
        if !filemgr.fileExistsAtPath(databasePath as String) {
            let milicalDB = FMDatabase(path: databasePath as String)
            if milicalDB == nil {
                print("Error: \(milicalDB.lastErrorMessage())")
            }
            
            if milicalDB.open(){
                let sql_stmt = "CREATE TABLE IF NOT EXISTS USER ( id INTEGER PRIMARY KEY, enterday TEXT, birthday TEXT, meetday TEXT, gname TEXT, bname TEXT, img_src TEXT)"
                
                if !milicalDB.executeStatements(sql_stmt){
                    print("Error: \(milicalDB.lastErrorMessage())")
                }
                
                milicalDB.close()
            } else {
                print("Error: \(milicalDB.lastErrorMessage())")
            }
        }
        
        
        
    }
    
    
    
    @IBAction func saveData(sender: AnyObject) {
        let milicalDB = FMDatabase(path: databasePath as String)
        
        if milicalDB.open() {
            // search if another record exist. if exist, delete it and insert new record
            let searchSQL = "SELECT * FROM USER WHERE id = 1"
            let searchResult:FMResultSet? = milicalDB.executeQuery(searchSQL, withArgumentsInArray: nil)
            
            if searchResult?.next() == true {
                let deleteSQL = "DELETE FROM USER WHERE id = 1"
                let delResult = milicalDB.executeUpdate(deleteSQL, withArgumentsInArray: nil)
                
                if !delResult {
                    status.text = "There was one record and we failed to delete it"
                    print("Error : \(milicalDB.lastErrorMessage())")
                } else {
                    
                    // record delete success. keep going insert new record
                    let insertSQL = "INSERT INTO USER (id, enterday, gname, bname) VALUES (1, '\(year) \(month) \(day)', '\(gomName.text!)', '\(gunName.text!)')"
                    
                    let insertResult = milicalDB.executeUpdate(insertSQL, withArgumentsInArray: nil)
                    
                    if !insertResult {
                        status.text = "Failed to add new record"
                        print("Error: \(milicalDB.lastErrorMessage())")
                    } else {
                        status.text = "delete exist record and new record added"
                        gomName.text = ""
                        gunName.text = ""
                        
                        
                    }
                }
            } else {
                
                //if record doesn't exist. 
                let insertSQL = "INSERT INTO USER (id, enterday, gname, bname) VALUES (1, '\(year) \(month) \(day)', '\(gomName.text!)', '\(gunName.text!)')"
                
                let insertResult = milicalDB.executeUpdate(insertSQL, withArgumentsInArray: nil)
                if !insertResult {
                    status.text = "Failed to add new record"
                    print("Error: \(milicalDB.lastErrorMessage())")
                } else {
                    status.text = "new record added"
                    gomName.text = ""
                    gunName.text = ""
                 
                }
                
            }
        } else {
            print("Error: \(milicalDB.lastErrorMessage())")
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[component][row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0 :
            year = pickerData[component][row]
            status.text = year
        case 1 :
            month = pickerData[component][row]
            status.text = month
        case 2 :
            day = pickerData[component][row]
            status.text = day
        default :
            print("Error")
        }
   
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
