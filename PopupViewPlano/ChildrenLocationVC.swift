//
//  ChildrenLocationVC.swift
//  PopupViewPlano
//
//  Created by Toe Wai Aung on 5/7/17.
//  Copyright © 2017 kotoeymb. All rights reserved.
//

import UIKit
//import MapKit
import GoogleMaps
import CoreLocation

class ChildrenLocationVC: UIViewController{
  
   
    var currentlocation : CLLocation!
    var markerLocation : GMSMarker?
    var currentZoom : Float = 0.0
    var mapView = GMSMapView()
    var cirlce: GMSCircle!
    var locationManager = CLLocationManager()
    var userLatitude = CLLocationDegrees()
    var userLongitude = CLLocationDegrees()
    
    let planoColor = UIColor(red: 104.0/255.0, green: 206.0/255.0, blue: 217.0/255.0, alpha: 1.0)
    let safeArea = UIImage(named: "safeArea")! as UIImage;
    
    @IBOutlet weak var btn350m: UIButton!
    @IBOutlet weak var btn550m: UIButton!
    @IBOutlet weak var btnOneK: UIButton!
    
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var viewGoogleMap: UIView!
    @IBOutlet weak var imgPinCenter: UIImageView!
    
    @IBOutlet weak var imgPinOverlay: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        let latitude : CLLocationDegrees = 16.775552
//        let longitude : CLLocationDegrees = 96.140380

        locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
      
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        
        currentZoom = 15

        self.lblLocation.text = "Please wait while fetching address"
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        mapView.isIndoorEnabled = false
//        self.mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        // [mapView animateToViewingAngle:45];
        
        cirlce = GMSCircle(position: mapView.camera.target, radius: 15)
        cirlce.fillColor = UIColor.red.withAlphaComponent(1)
        cirlce.map = mapView
       
        
        viewGoogleMap.addSubview(mapView)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            self.mapView.frame = self.viewGoogleMap.frame
            self.view.layoutIfNeeded()
        }
        self.imgPinCenter.center = CGPoint(x: self.viewGoogleMap.center.x, y: self.viewGoogleMap.center.y-(self.imgPinCenter.frame.size.height/2))

//        UIView.animate(withDuration: 0.0, animations: {
//            self.imgPinCenter.center = CGPoint(x: self.viewGoogleMap.center.x, y: self.viewGoogleMap.center.y-(self.imgPinCenter.frame.size.height/2))
//        })
//       
//        activitytLocation.startAnimating()
        self.getAddressForMapCenter()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.imgPinOverlay.isHidden = true
        self.imgPinCenter.center = CGPoint(x: self.viewGoogleMap.center.x, y: self.viewGoogleMap.center.y-(self.imgPinCenter.frame.size.height/2))

//        UIView.animate(withDuration: 0.0, animations: {
//            self.imgPinCenter.center = CGPoint(x: self.viewGoogleMap.center.x, y: self.viewGoogleMap.center.y-(self.imgPinCenter.frame.size.height/2))
////            self.imgPinOverlay.center = CGPoint(x: self.viewGoogleMap.center.x, y: self.viewGoogleMap.center.y)
//        })
        
    }
    
    func getAddressForMapCenter() {
        
        let point : CGPoint = mapView.center
        let coordinate : CLLocationCoordinate2D = mapView.projection.coordinate(for: point)
        let location =  CLLocation.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.GetAnnotationUsingCoordinated(location)
        print("\(location)")
    }
    
    
     // get current address from geocode from apple, from location lat long
    func GetAnnotationUsingCoordinated(_ location : CLLocation) {
       
        GMSGeocoder().reverseGeocodeCoordinate(location.coordinate) { (response, error) in
//            self.imgPinCenter.isHidden = true
            var strAddresMain : String = ""
            
            if let address : GMSAddress = response?.firstResult() {
                if let lines = address.lines  {
                    if (lines.count > 0) {
                        if lines.count > 0 {
                            if lines[0].length > 0 {
                                strAddresMain = strAddresMain + lines[0]
                            }
                        }
                    }
                    
                    if (lines.count > 1) {
                        if (lines[1].length > 0) {
                            if (strAddresMain.length > 0){
                                strAddresMain = strAddresMain + ", \(lines[1])"
                            } else {
                                strAddresMain = strAddresMain + "\(lines[1])"
                            }
                        }
                    }
                    
                    if (strAddresMain.length > 0) {
                        print("strAddresMain : \(strAddresMain)")
                        
                        self.lblLocation.text = strAddresMain
                        
                        var strSubTitle = ""
                        if let locality = address.locality {
                            strSubTitle = locality
                        }
                        
                        if let administrativeArea = address.administrativeArea {
                            if strSubTitle.length > 0 {
                                strSubTitle = "\(strSubTitle), \(administrativeArea)"
                            }
                            else {
                                strSubTitle = administrativeArea
                            }
                        }
                        
                        if let country = address.country {
                            if strSubTitle.length > 0 {
                                strSubTitle = "\(strSubTitle), \(country)"
                            }
                            else {
                                strSubTitle = country
                            }
                        }
                        
                        
                        if strSubTitle.length > 0 {
                            self.addPin_with_Title(strAddresMain, subTitle: strSubTitle, location: location)
                        }
                        else {
                            self.addPin_with_Title(strAddresMain, subTitle: "Your address", location: location)
                        }
                    }
                    else {
                        print("Location address not found")
                        self.lblLocation.text = "Location address not found"
                    }
                }
                else {
                    self.lblLocation.text = "Please change location, address is not available"
                    
                    print("Please change location, address is not available")
                }
            }
            else {
                self.lblLocation.text  = "Address is not available"
                
                print("Address is not available")
            }
        }
    }
    
    func addPin_with_Title(_ title: String, subTitle: String, location : CLLocation) {
        
        if markerLocation == nil {
            markerLocation = GMSMarker.init()//GMSMarker.init(position: location.coordinate)
        }
        //add Marker on google map
//        self.addMarkerOnGoogleMap(title, subTitle: subTitle, location: location)
    }
    
    func addMarkerOnGoogleMap(_ title: String, subTitle: String, location: CLLocation) {
        //update title
        //        var titleMain = (title.length > 20) ? ("\(title.substring(to: 20))") : title
        let position : CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        markerLocation = GMSMarker(position: position)
        markerLocation?.title  = title
        markerLocation?.snippet = subTitle
        markerLocation?.icon = #imageLiteral(resourceName: "iconPin")
//        markerLocation?.appearAnimation = .pop
        mapView.clear()
        markerLocation?.map = mapView
    }

   // For Button Click Event
    @IBAction func btn350mClick(_ sender: Any) {
        
//        var imageViewObject :UIImageView
        
//        imgPinCenter = UIImageView(frame:CGRect(x:0,y:0,width:100,height:100))
          imgPinCenter.image = #imageLiteral(resourceName: "safeArea")
//        imageViewObject.image = UIImage(named:"afternoon")
        
//        self.view.addSubview(imageViewObject)
        
//        self.view.sendSubview(toBack: imageViewObject)
        
//        self.imgPinOverlay.isHidden = false
//        
//        self.imgPinCenter.isHidden = true;
//        imgPinCenter =  UIImageView(image: imgPinOverlay)
//        UIImageView(image: image)
//
//        self.imgPinOverlay.isHidden = false
//        self.imgPinCenter.isHidden = true;
//        self.imgPinCenter.image = #imageLiteral(resourceName: "safeArea")
        btn350m.backgroundColor = planoColor
        btn350m.setTitleColor(UIColor.white, for: UIControlState.normal)
        
        btn550m.backgroundColor = UIColor.white
        btn550m.setTitleColor(planoColor, for: UIControlState.normal)
        
        btnOneK.backgroundColor = UIColor.white
        btnOneK.setTitleColor(planoColor, for: UIControlState.normal)
        
        let point : CGPoint = mapView.center
        let coordinate : CLLocationCoordinate2D = mapView.projection.coordinate(for: point)
        currentZoom = 15;
        //        if((sender as! UIButton).tag == 0) {
        //            print("btnZoominClicked")
        //        }
        
        let camera : GMSCameraPosition = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: currentZoom)
        mapView.camera = camera
    }
    
    @IBAction func btn550mClick(_ sender: Any) {
        imgPinCenter.image = #imageLiteral(resourceName: "safeArea")
//        self.imgPinCenter.isHidden = true;
//        self.imgPinOverlay.isHidden = false
        
        
        btn550m.backgroundColor = planoColor
        btn550m.setTitleColor(UIColor.white, for: UIControlState.normal)
        
        btn350m.backgroundColor = UIColor.white
        btn350m.setTitleColor(planoColor, for: UIControlState.normal)
        
        btnOneK.backgroundColor = UIColor.white
        btnOneK.setTitleColor(planoColor, for: UIControlState.normal)
        
        let point : CGPoint = mapView.center
        let coordinate : CLLocationCoordinate2D = mapView.projection.coordinate(for: point)
        
        currentZoom = 14;
        let camera : GMSCameraPosition = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: currentZoom)
        mapView.camera = camera
    }
    
    @IBAction func btnOneKClick(_ sender: Any) {
        imgPinCenter.image = #imageLiteral(resourceName: "safeArea")
//        self.imgPinCenter.isHidden = true;
//        self.imgPinOverlay.isHidden = false
        
        btnOneK.backgroundColor = planoColor
        btnOneK.setTitleColor(UIColor.white, for: UIControlState.normal)
        
        btn550m.backgroundColor = UIColor.white
        btn550m.setTitleColor(planoColor, for: UIControlState.normal)
        
        btn350m.backgroundColor = UIColor.white
        btn350m.setTitleColor(planoColor, for: UIControlState.normal)
       
        let point : CGPoint = mapView.center
        let coordinate : CLLocationCoordinate2D = mapView.projection.coordinate(for: point)
        
        currentZoom = 13;
        let camera : GMSCameraPosition = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: currentZoom)
        mapView.camera = camera
    }
    
    @IBAction func btnSave(_ sender: Any) {
         self.mapView.settings.myLocationButton = true

    }
    @IBAction func btnCancel(_ sender: Any) {
          self.navigationController?.popViewController(animated: true)
//        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnBack(_ sender: Any) {
      self.navigationController?.popViewController(animated: true)
//        self.dismiss(animated: true, completion: nil)
    }
}

extension ChildrenLocationVC : GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        //print("didChangeCameraPosition: \(position)")
        mapView.clear()
        
        //markerLocation?.map = mapView
        
//        self.imgPinCenter.isHidden = false
         self.getAddressForMapCenter()
//        activitytLocation.startAnimating()
        
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
//        self.imgPinCenter.isHidden = false
        self.getAddressForMapCenter()
//        reverseGeocodeCoordinate(position.target)

    }
    func mapView(mapView: GMSMapView!, didChangeCameraPosition position: GMSCameraPosition!) {
        print("\(position.target.latitude) \(position.target.longitude)")
        cirlce.position = position.target
    }

//    func mapView(_ mapView: GMSMapView, didTap overlay: GMSOverlay)
//    {
//       cirlce.position = position.target
//        print("User Tapped Layer: \(overlay)")
//    }


}



extension ChildrenLocationVC: CLLocationManagerDelegate {
    
    func locationManager( _ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations.first {
            
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            
            locationManager.stopUpdatingLocation()
            
        }
        

//         let camera : GMSCameraPosition = GMSCameraPosition.camera(withLatitude: userLatitude, longitude: userLongitude, zoom: currentZoom, bearing: 3, viewingAngle: 0)
//        mapView = GMSMapView.map(withFrame: viewGoogleMap.frame, camera: camera)
//        mapView.camera = camera
////        viewGoogleMap.addSubview(mapView)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
//            self.mapView.frame = self.viewGoogleMap.frame
//            self.view.layoutIfNeeded()
//        }
//        
//        UIView.animate(withDuration: 0.1, animations: {
//            self.imgPinCenter.center = CGPoint(x: self.viewGoogleMap.center.x, y: self.viewGoogleMap.center.y-(self.imgPinCenter.frame.size.height/2))
//        })
    }
       // 2
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        // 3
        if status == .authorizedWhenInUse {
            
            // 4
            locationManager.startUpdatingLocation()
            
            //5
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    // 6
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            // 7
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            
            // 8
            locationManager.stopUpdatingLocation()
        }
        
    }
}

