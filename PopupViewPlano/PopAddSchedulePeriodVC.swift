//
//  Pop_AddSchedulePeriodViewController.swift
//  PopupViewPlano
//
//  Created by Toe Wai Aung on 5/4/17.
//  Copyright © 2017 kotoeymb. All rights reserved.
//

import UIKit

class PopAddSchedulePeriodVC: UIViewController {
   
    var isFromOpened  : Bool = false
    var isToOpened : Bool = false
    var testhight : Bool = false
    @IBOutlet weak var btnForm: UIButton!
    @IBOutlet weak var btnTo: UIButton!
    @IBOutlet weak var btnSchedulePeriod: UIButton!
    
    @IBOutlet weak var fromTimePicker: UIDatePicker!
    @IBOutlet weak var toTimePicker: UIDatePicker!
    
    @IBOutlet weak var timePickerHeight: NSLayoutConstraint!
    
    var daylist:[String] = ["EveryDay", "Mon","Tue", "Wed","Thus", "Fri","Sat", "Sun"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timePickerHeight.constant = 0
        self.toTimePicker.isHidden = true
        self.toTimePicker.alpha = 0
        self.fromTimePicker.isHidden = true
        self.fromTimePicker.alpha = 0
 
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:00 a"
        
        let strFromDate = dateFormatter.string(from: fromTimePicker.date.addingTimeInterval(0))
        let strToDate = dateFormatter.string(from: toTimePicker.date.addingTimeInterval(3600))
        
        self.btnForm.setTitle(strFromDate,for: .normal)
        self.btnTo.setTitle(strToDate,for: .normal)
        
        self.btnForm.addTarget(self, action: #selector(FromTimeClicked(_:)), for: .touchUpInside)
        self.btnTo.addTarget(self, action: #selector(self.ToTimeClick(_:)), for: .touchUpInside)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func FromTimeClicked(_ sender: UIButton) {
    
        if (!isFromOpened) {
            toTimeCloseClicked()
            self.FromTime_OpenClicked()
            
        }else{
            self.FromTime_CloseClicked()
        }
    }
    
    func FromTime_OpenClicked() {
        
        isFromOpened = true
        self.fromTimePicker.alpha = 1
        UIView.animate(withDuration: 0.5) { () -> Void in
            self.fromTimePicker.isHidden = false
            self.timePickerHeight.constant = 126.0
            self.view.layoutIfNeeded()
        }

    }
    
     func FromTime_CloseClicked() {
        
        isFromOpened = false

        self.fromTimePicker.alpha = 0
        self.fromTimePicker.isHidden = true
        self.btnTo.isEnabled = true
    
        UIView.animate(withDuration: 0.5) { () -> Void in
            self.timePickerHeight.constant = 0.0
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func ToTimeClick(_ sender: UIButton) {
        
        if (!isToOpened) {
            
            FromTime_CloseClicked()
            
            self.toTimeOpenClicked()
            
        }else{
            self.toTimeCloseClicked()
        }
    }
    
    func toTimeOpenClicked() {
        
        isToOpened = true

        UIView.animate(withDuration: 0.5) { () -> Void in
            self.toTimePicker.alpha = 1
            self.toTimePicker.isHidden = false
            self.timePickerHeight.constant = 126.0
            self.view.layoutIfNeeded()
        }
        
    }
    
    func toTimeCloseClicked() {
        
        isToOpened = false
        self.btnForm.isEnabled = true
        self.toTimePicker.alpha = 0
        self.toTimePicker.isHidden = true
        
        UIView.animate(withDuration: 0.5) { () -> Void in
            self.timePickerHeight.constant = 0.0
            self.view.layoutIfNeeded()
        }
    }

    @IBAction func FromTimePicker(_ sender: Any) {
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm  a"
        let strDate = dateFormatter.string(from: fromTimePicker.date)
        print("\(strDate)")
        self.btnForm.setTitle(strDate,for: .normal)
        
    }
    
    
    @IBAction func ToTimerPickerView(_ sender: Any) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm  a"
        let strDate = dateFormatter.string(from: toTimePicker.date)
        print("\(strDate)")
        
        self.btnTo.setTitle(strDate, for: .normal)
    }
    func userDidEnterData(data: String ) {
        print("\(data)")
        self.btnSchedulePeriod.setTitle(data, for: .normal)
        
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPeriodVC" {
            let sendingVC: PopScheduleDayVC = segue.destination as! PopScheduleDayVC
            sendingVC.period_delegate = self
        }
    }
    
   }
extension PopAddSchedulePeriodVC : SchedulePeriodDelegate{
    
}
