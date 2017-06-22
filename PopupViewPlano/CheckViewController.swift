//
//  CheckViewController.swift
//  PopupViewPlano
//
//  Created by Toe Wai Aung on 5/29/17.
//  Copyright © 2017 kotoeymb. All rights reserved.
//

import UIKit
import GoogleMaps



class CheckViewController: UIViewController {
    var str1 : NSString = ""
    var str2 : NSString = ""
    var GMSPosition : GMSCameraPosition?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//       self.userLocationMapDelegate = true
        // Do any additional setup after loading the view.
        print((str1),(GMSPosition) as Any,(str2))
       
    }
    func didRecieveMapData(_ boundaryName: String, _ userMapPosition: CLLocationCoordinate2D, _ placeID: String, _ Address: String, _ description: String, _ boundarySize: String) {
       print("UserData ->\n\(boundaryName)\n\(userMapPosition)\n\(boundarySize)\n \(placeID)\n \(Address)\n \(description)")
    }
        
        
        //    func didRecieveMapData(_ boundaryName:String, _ userMapPosition : CLLocationCoordinate2D, _ boundarySize:String){
//        print("UserData ->\n\(boundaryName)\n\(userMapPosition)\n\(boundarySize)")
//        
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMap" {
            let sendingVC: ChildrenLocationVC = segue.destination as! ChildrenLocationVC
            sendingVC.mapdelegate = self
        }
    }
   }

extension CheckViewController : userLocationMapDelegate {
    internal func didRecieveMapData(_ boundaryName: String, _ userMapPosition: CLLocationCoordinate2D, _ placeID: String, _ Address: String, _ AddressTitle: String, _ description: String, _ boundarySize: String) {
        print("UserData\(boundaryName),BoundaryName\(userMapPosition),MapPosition,\(boundarySize),BoundarySize") 
    }

    func didRecieveMapData(boundaryName:String, userMapPosition : GMSCameraPosition, boundarySize:String){
        print("UserData\(boundaryName),BoundaryName\(userMapPosition),MapPosition,\(boundarySize),BoundarySize")
    }
}
    
