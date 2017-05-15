//
//  PopScheduleDayVC.swift
//  PopupViewPlano
//
//  Created by Toe Wai Aung on 5/4/17.
//  Copyright © 2017 kotoeymb. All rights reserved.
//

import UIKit



protocol SchedulePeriodDelegate {
     func userDidEnterData(data: String)
}
    class PopScheduleDayVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
//        var selectedCountryObj:PeriodData?
//        weak var period_delegate: SchedulePeriodDelegate?
        @IBOutlet weak var dayTable: UITableView!
        var numberArray: [Int] = []
        var temp_arr: [String]  = []
        var selectedArray:[Int] = [0,0,0,0,0,0,0,0]
        var temp_array:[Int] = [0,1,1,1,1,1,1,1]
        var daylist:[String] = ["EveryDay", "Monday","Tuesday", "Wednesday","Thursday", "Friday","Saturday", "Sunday"]
        var show_daylist:[String] = ["EveryDay", "Mon","Tue", "Wed","Thus", "Fri","Sat", "Sun"]
        var period_delegate: SchedulePeriodDelegate? = nil // for delegate
        
    override func viewDidLoad() {
        super.viewDidLoad()
        for index in 1...8 {
            
            numberArray.append(index)
            
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
            return numberArray.count;
            
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) ->CGFloat
        {
            return 42.0
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        {
            
            let cell:PopDayTableCell = dayTable.dequeueReusableCell(withIdentifier: "DayPeriodCell") as! PopDayTableCell
            
            let date_lbl = daylist[indexPath.row]
            cell.lbl_day?.text = String("\(date_lbl) ")
            let cellValue = selectedArray[indexPath.row]
            let cellValueBool = cellValue == 1 ? true : false
            cell.checkbox.setOn(cellValueBool,animated : true)
            cell.isSelected = cellValueBool
            
            return cell
        }
        
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let cell:PopDayTableCell = tableView.cellForRow(at: indexPath) as! PopDayTableCell
            
            
            if(indexPath.row == 0){
                //        isSelected = true
                print("DayAll")
                cell.checkbox.setOn(true , animated : true)
                selectedArray = [1,1,1,1,1,1,1,1]
                
                for i in 1...7 {
                    let ip = IndexPath(row: i, section: 0)
                    tableView.selectRow(at: ip, animated: false, scrollPosition: .none)
                    let insideCell:PopDayTableCell = tableView.cellForRow(at: ip) as! PopDayTableCell
                    insideCell.checkbox.setOn(true,animated : true)
                }
                
            }else{
                
                cell.checkbox.setOn(true , animated : true)
                self.selectedArray[indexPath.row] = 1
                let ipp = IndexPath(row: 0, section: 0)
                if(selectedArray[0]==0){
                    
                    if(selectedArray == temp_array){
                        selectedArray[0] = 1;
                        let insideCell:PopDayTableCell = tableView.cellForRow(at: ipp) as! PopDayTableCell
                        insideCell.checkbox.setOn(true,animated : true)
                    }
                }
            }
            
        }
        
        func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
            let cell:PopDayTableCell = tableView.cellForRow(at: indexPath) as! PopDayTableCell
            // tableView.reloadData()
            
            if(indexPath.row == 0){
                cell.checkbox.setOn(false , animated : true)
                selectedArray = [0,0,0,0,0,0,0,0]
                for i in 1...7 {
                    let ip = IndexPath(row: i, section: 0)
                    tableView.deselectRow(at: ip, animated: false)
                    let insideCell:PopDayTableCell = tableView.cellForRow(at: ip) as! PopDayTableCell
                    insideCell.checkbox.setOn(false,animated : true)
                }
                
            }else{
                
                cell.checkbox.setOn(false , animated : true)
                self.selectedArray[indexPath.row] = 0
                
                let ipp = IndexPath(row: 0, section: 0)
                
                if(selectedArray[0] == 1){
                    selectedArray[0] = 0;
                    let insideCell:PopDayTableCell = tableView.cellForRow(at: ipp) as! PopDayTableCell
                    insideCell.checkbox.setOn(false,animated : true)
                    
                    
                }
            }
            
        }
        
        func report(info: String) {
            print("delegate: \(info)")
        }
        
        
        @IBAction func Btn_CloseClick(_ sender: Any) {
            
              self.dismiss(animated: true, completion: nil)
            
        }
        
        @IBAction func Btn_DoneClick(_ sender: Any) {
            
            if (period_delegate != nil)
            {
                if(selectedArray[0]==1){
                    temp_arr.append(show_daylist[0])
                }else{
                    for i in 1...7{
                    
                        if(selectedArray[i]==1){
                            let str_daylist: String = show_daylist[i]
                            temp_arr.append(str_daylist)
                        }
                        
                    }
                }
                let periodString = temp_arr.joined(separator: " ")
                print("\(periodString)")
                
                if (selectedArray.count != 0) {
                    period_delegate?.userDidEnterData(data: periodString)
                    dismiss(animated: true, completion: nil)
                }else{
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
}
