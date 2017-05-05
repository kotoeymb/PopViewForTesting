//
//  Pop_AddSchedulePeriodViewController.swift
//  PopupViewPlano
//
//  Created by Toe Wai Aung on 5/4/17.
//  Copyright © 2017 kotoeymb. All rights reserved.
//

import UIKit

class Pop_AddSchedulePeriodVC: UIViewController {
    var str_schedulpreiod : String = String()
    var isHighLight  : Bool = false
    var forHighLight : Bool = false
    var testhight : Bool = false
    @IBOutlet weak var btn_Form: UIButton!
    @IBOutlet weak var btn_To: UIButton!
    @IBOutlet weak var btn_SchedulePeriod: UIButton!
    
    @IBOutlet weak var FromTimePicker: UIDatePicker!
    @IBOutlet weak var ToTimePicker: UIDatePicker!
    
    @IBOutlet weak var TimePickerHeight: NSLayoutConstraint!
    
    var daylist:[String] = ["EveryDay", "Mon","Tue", "Wed","Thus", "Fri","Sat", "Sun"]

   //  @IBOutlet weak var FromTimePickerheight: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        FromTimePickerheight.constant = 0
        TimePickerHeight.constant = 0
        self.ToTimePicker.isHidden = true
        self.ToTimePicker.alpha = 0
        self.FromTimePicker.isHidden = true
        self.FromTimePicker.alpha = 0
 
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:00 a"
        
        let str_fromdate = dateFormatter.string(from: FromTimePicker.date.addingTimeInterval(0))
        let str_todate = dateFormatter.string(from: ToTimePicker.date.addingTimeInterval(3600))
        
        
        self.btn_Form.setTitle(str_fromdate,for: .normal)
        
        self.btn_To.setTitle(str_todate,for: .normal)
//        period_delegate = self
//        self.ToTimePicker.isHidden = true
//        self.ToTimePicker.alpha = 0
//        self.FromTimePicker.isHidden = true
//        self.FromTimePicker.alpha = 0

        // Do any additional setup after loading the view.
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    @IBAction func ToTimeClick(_ sender: UIButton) {
        
        self.btn_Form.isEnabled = false
        
        if(!forHighLight){
        
            UIView.animate(withDuration: 0.5) { () -> Void in
                self.ToTimePicker.alpha = 1
                self.ToTimePicker.isHidden = false
                self.TimePickerHeight.constant = 126.0
                self.view.layoutIfNeeded()

            }
        }
        else {
                self.btn_Form.isEnabled = true
                self.ToTimePicker.alpha = 0
                self.ToTimePicker.isHidden = true
            
                UIView.animate(withDuration: 0.5) { () -> Void in
                self.TimePickerHeight.constant = 0.0
                self.view.layoutIfNeeded()

            }
        }
        forHighLight = !forHighLight
        
    }
    @IBAction func FromTimeClicked(_ sender: UIButton) {
       
        self.btn_To.isEnabled = false
        
        if(!isHighLight){
            
                self.FromTimePicker.alpha = 1
            
                UIView.animate(withDuration: 0.5) { () -> Void in
                self.FromTimePicker.isHidden = false
                self.TimePickerHeight.constant = 126.0
                self.view.layoutIfNeeded()
                }
            }
                else {
//            self.ToTimePicker.alpha = 0
                self.FromTimePicker.alpha = 0
                self.FromTimePicker.isHidden = true
                self.btn_To.isEnabled = true
            
                UIView.animate(withDuration: 0.5) { () -> Void in
                self.TimePickerHeight.constant = 0.0
                self.view.layoutIfNeeded()
            }
        }
        isHighLight = !isHighLight
        
    }
   
    @IBAction func FromTimePicker(_ sender: Any) {
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm  a"
        let strDate = dateFormatter.string(from: FromTimePicker.date)
        print("\(strDate)")
        self.btn_Form.setTitle(strDate,for: .normal)
        
    }
    
    
    @IBAction func ToTimerPickerView(_ sender: Any) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm  a"
        let strDate = dateFormatter.string(from: ToTimePicker.date)
        print("\(strDate)")
        
        self.btn_To.setTitle(strDate, for: .normal)
    }
    func userDidEnterData(data: String ) {
        print("\(data)")
        self.btn_SchedulePeriod.setTitle(data, for: .normal)
        
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPeriodVC" {
            let sendingVC: PopScheduleDayVC = segue.destination as! PopScheduleDayVC
            sendingVC.period_delegate = self
        }
    }
    
   }
extension Pop_AddSchedulePeriodVC : SchedulePeriodDelegate{
    
}
