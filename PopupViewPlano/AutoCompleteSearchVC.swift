//
//  AutoCompleteSearchVC.swift
//  PopupViewPlano
//
//  Created by Toe Wai Aung on 5/15/17.
//  Copyright © 2017 kotoeymb. All rights reserved.
//

import UIKit

class AutoCompleteSearchVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBack(_ sender: Any) {
//         self.dismiss(animated: true, completion: nil)
         self.navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}