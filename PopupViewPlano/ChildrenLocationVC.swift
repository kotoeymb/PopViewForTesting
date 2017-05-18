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
import GooglePlaces

class ChildrenLocationVC: UIViewController{
  
   
    var currentlocation : CLLocation!
    var markerLocation : GMSMarker?
    var currentZoom : Float = 0.0
    var mapView = GMSMapView()
    var locationManager = CLLocationManager()
//    var userLatitude = CLLocationDegrees()
//    var userLongitude = CLLocationDegrees()
    
   
    
    
    let planoColor = UIColor(red: 104.0/255.0, green: 206.0/255.0, blue: 217.0/255.0, alpha: 1.0)
    let safeArea = UIImage(named: "safeArea")! as UIImage;
    
    @IBOutlet weak var btn350m: UIButton!
    @IBOutlet weak var btn550m: UIButton!
    @IBOutlet weak var btnOneK: UIButton!
    
    @IBOutlet weak var lblLocationTitle: UILabel!
    @IBOutlet weak var lblLocationAddress: UILabel!
    
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

        self.lblLocationAddress.text = "Please wait while fetching address"
        mapView.delegate = self
        mapView.isMyLocationEnabled = true   // for current location enable
        mapView.settings.myLocationButton = true // current location btn
        mapView.settings.compassButton = true  // compass
        mapView.isIndoorEnabled = false
//        self.mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        // [mapView animateToViewingAngle:45];
        viewGoogleMap.addSubview(mapView)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            self.mapView.frame = self.viewGoogleMap.frame
            self.view.layoutIfNeeded()
        }

        UIView.animate(withDuration: 0.3, animations: {
            self.imgPinCenter.center = CGPoint(x: self.viewGoogleMap.center.x, y: self.viewGoogleMap.center.y-(self.imgPinCenter.frame.size.height/2))
//             self.imgPinCenter.center = CGPoint(x: self.viewGoogleMap.center.x, y: self.viewGoogleMap.center.y-100)
        })
//        activitytLocation.startAnimating()
        self.getAddressForMapCenter()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: 0.3, animations: {
            self.imgPinCenter.center = CGPoint(x: self.viewGoogleMap.center.x, y: self.viewGoogleMap.center.y-(self.imgPinCenter.frame.size.height/2))
        })

    }
    
    func getAddressForMapCenter() {
        
        let point : CGPoint = mapView.center// CGPoint(x: self.viewGoogleMap.center.x, y: self.viewGoogleMap.center.y)
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
                        
                        self.lblLocationAddress.text = strAddresMain
                        
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
                        self.lblLocationAddress.text = "Location address not found"
                    }
                }
                else {
                    self.lblLocationAddress.text = "Please change location, address is not available"
                    
                    print("Please change location, address is not available")
                }
            }
            else {
                self.lblLocationAddress.text  = "Address is not available"
                
                print("Address is not available")
            }
        }
    }
    
    func addPin_with_Title(_ title: String, subTitle: String, location : CLLocation) {
        
        if markerLocation == nil {
            markerLocation = GMSMarker.init()//GMSMarker.init(position: location.coordinate)
        }
//        add Marker on google map
//        self.addMarkerOnGoogleMap(title, subTitle: subTitle, location: location)
    }
    
    func addMarkerOnGoogleMap(_ title: String, subTitle: String, location: CLLocation) {
     
        let position : CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        markerLocation = GMSMarker(position: position)
        markerLocation?.title  = title
        markerLocation?.snippet = subTitle
        markerLocation?.icon = #imageLiteral(resourceName: "iconPin")
        mapView.clear()
        markerLocation?.map = mapView
    }

   // For Button Click Event
    @IBAction func btn350mClick(_ sender: Any) {
        
        imgPinCenter.image = #imageLiteral(resourceName: "safeArea")
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
    
    @IBAction func btnAutoSearchClick(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
//        func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//            if segue.identifier == "gSearch" {
//                let sendingVC: AutoCompleteSearchVC = segue.destination as! AutoCompleteSearchVC
////                sendingVC.period_delegate = self
//            }
//        }
    }
    
    @IBAction func btn550mClick(_ sender: Any) {
        imgPinCenter.image = #imageLiteral(resourceName: "safeArea")
        
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
//      markerLocation?.map = mapView
         self.getAddressForMapCenter()
//        activitytLocation.startAnimating()
        
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        self.getAddressForMapCenter()
//        reverseGeocodeCoordinate(position.target)

    }
    func mapView(mapView: GMSMapView!, didChangeCameraPosition position: GMSCameraPosition!) {
        print("\(position.target.latitude) \(position.target.longitude)")
//        cirlce.position = position.target
        
        
        
//        test(param1: "abc", param2: "def")
        
        test("abc", "def")
        
    }
    
    func test(_ param1:String, _ param2:String){
        
    }
    

}



extension ChildrenLocationVC: CLLocationManagerDelegate {
    
    func locationManager( _ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations.first {
            
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            
            locationManager.stopUpdatingLocation()
            
        }
    }
       // 2
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways: break
        // ...
        case .notDetermined:
            manager.requestAlwaysAuthorization()
        case .authorizedWhenInUse, .restricted, .denied: // authorizedAlways authorizedWhenInUse
            let alertController = UIAlertController(
                title: "Background Location Access Disabled",
                message: "In order to be notified about adorable kittens near you, please open this app's settings and set location access to 'Always'.",
                preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.openURL(url as URL)
                }
            }
            alertController.addAction(openAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    private func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            // 7
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            
            // 8
            locationManager.stopUpdatingLocation()
        }
        
    }
}

extension ChildrenLocationVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        
        self.lblLocationTitle.isHidden = false
        
//        self.searchViewHeight.constant = self.locationTitleHeight.constant + self.locationAddressHeight.constant + 50
        
        self.lblLocationTitle.text = place.name
        self.lblLocationAddress.text = place.formattedAddress
        print("\(self.lblLocationTitle.text)")
        
        /*
         Place name: Sule Pagoda
         Place address
         */
        self.mapView.camera = GMSCameraPosition(target: place.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        self.locationManager.stopUpdatingLocation()
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
