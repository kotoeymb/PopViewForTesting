//
//  ChildrenLocationVC.swift
//  PopupViewPlano
//
//  Created by Toe Wai Aung on 5/7/17.
//  Copyright © 2017 kotoeymb. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import GooglePlaces


protocol userLocationMapDelegate: class {
    func didRecieveMapData(_ boundaryName:String,_ userMapPosition : CLLocationCoordinate2D,_ placeID:String,_ Address:String,_ AddressTitle:String ,_ description:String , _ boundarySize:String )
}

class ChildrenLocationVC: UIViewController{
   
    var placesClient: GMSPlacesClient!
    var userPlace:GMSPlace!
    
    var userBoundarySize : String = ""
    var isButtonClicked : Bool = false
    var mapPostion : GMSCameraPosition!
    var isPlaceTitle : Bool = false
    var tempLbl : String!
    var currentlocation : CLLocation!
    var markerLocation : GMSMarker?
    
    var currentZoom : Float = 0.0
    
    var locationManager = CLLocationManager()
    var userLatitude = CLLocationDegrees()
    var userLongitude = CLLocationDegrees()
    
    let planoColor = UIColor(red: 104.0/255.0, green: 206.0/255.0, blue: 217.0/255.0, alpha: 1.0)
    let safeArea = UIImage(named: "safeArea")! as UIImage;
    
    @IBOutlet weak var btn350m: UIButton!
    @IBOutlet weak var btn550m: UIButton!
    @IBOutlet weak var btnOneK: UIButton!
   
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var viewMapView: UIView!
    
    @IBOutlet weak var viewTextView: UIView!
    @IBOutlet weak var viewSearchView: UIView!
    @IBOutlet weak var lblLocationTitle: UILabel!
    @IBOutlet weak var lblLocationAddress: UILabel!
    @IBOutlet weak var imgPinCenter: UIImageView!
    
    @IBOutlet weak var imgPinOverlay: UIImageView!
    var mapdelegate: userLocationMapDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placesClient = GMSPlacesClient.shared()
        locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        
        currentZoom = 15
        self.lblLocationTitle.text = ""
        self.lblLocationAddress.text = "Please wait while fetching address"
        
        lblLocationAddress.lineBreakMode = .byWordWrapping
        lblLocationAddress.numberOfLines = 0
        viewSearchView.superview?.bringSubview(toFront: viewSearchView)
        viewTextView.superview?.bringSubview(toFront: viewTextView)
 
        mapView.delegate = self
        mapView.isMyLocationEnabled = true   // for current location enable
        mapView.settings.myLocationButton = true // current location btn
        mapView.settings.compassButton = true  // compass
        mapView.isIndoorEnabled = false
        mapView.backgroundColor = UIColor.clear
        
        
        if(isButtonClicked == true){
            
            UIView.animate(withDuration: 0.3, animations: {
                self.imgPinCenter.center = CGPoint(x: self.mapView.center.x, y: self.mapView.center.y)
            })
            
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                self.imgPinCenter.center = CGPoint(x: self.mapView.center.x, y: self.mapView.center.y-(self.imgPinCenter.frame.size.height/2))
            })
        }
        self.getAddressForMapCenter()
        
    
        
        
    }
    func getplaceID(){
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
                    if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    //                    self.nameLabel.text = place.name
                    //                    self.addressLabel.text = place.formattedAddress?.components(separatedBy: ", ")
                    //                        .joined(separator: "\n")
                    print(place.placeID)
                   self.userPlace = place
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(isButtonClicked == true){
            
            UIView.animate(withDuration: 0.3, animations: {
                self.imgPinCenter.center = CGPoint(x: self.mapView.center.x, y: self.mapView.center.y)
            })
            
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                self.imgPinCenter.center = CGPoint(x: self.mapView.center.x, y: self.mapView.center.y-(self.imgPinCenter.frame.size.height/2))
            })
        }

    }
    
    func getAddressForMapCenter() {
        
       let point : CGPoint =  CGPoint(x: self.mapView.center.x, y: self.mapView.center.y)
        let coordinate : CLLocationCoordinate2D = mapView.projection.coordinate(for: point)
        let location =  CLLocation.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.GetAnnotationUsingCoordinated(location)
        
        print("\(location)")
    }
    
     // get current address from geocode from apple, from location lat long
    func GetAnnotationUsingCoordinated(_ location : CLLocation) {
       
        GMSGeocoder().reverseGeocodeCoordinate(location.coordinate) { (response, error) in
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
                        if(self.isPlaceTitle == true){
                            
                            self.lblLocationTitle.text = self.tempLbl
                            print("isPlaceTitleTrue")
                            self.isPlaceTitle = false
                            
                            
                        }else{
                            self.lblLocationTitle.text = ""
                        }
                        
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
    
    func addGMSCameraPosition(_ latitude: CLLocationDegrees,_ longitude: CLLocationDegrees,_ zoom: Float) {
        
        if(isButtonClicked == true){
        
            UIView.animate(withDuration: 0.3, animations: {
                self.imgPinCenter.center = CGPoint(x: self.mapView.center.x, y: self.mapView.center.y)
            })
        
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                self.imgPinCenter.center = CGPoint(x: self.mapView.center.x, y: self.mapView.center.y-(self.imgPinCenter.frame.size.height/2))
            })
        }
        
        let cameras : GMSCameraPosition = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoom)
        
        mapView.camera = cameras
        
        
    }
   
    func addPin_with_Title(_ title: String, subTitle: String, location : CLLocation) {
        
        if markerLocation == nil {
            markerLocation = GMSMarker.init() //GMSMarker.init(position: location.coordinate)
        }
    }
    
//    func addMarkerOnGoogleMap(_ title: String, subTitle: String, location: CLLocation) {
//        //update title
//        //        var titleMain = (title.length > 20) ? ("\(title.substring(to: 20))") : title
//        let position : CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
//        markerLocation = GMSMarker(position: position)
//        markerLocation?.title  = title
//        markerLocation?.snippet = subTitle
////        markerLocation?.icon = #imageLiteral(resourceName: "iconPin")
//        mapView.clear()
////        markerLocation?.position
//        
//        markerLocation?.map = mapView
//    }
    
    @IBAction func btnAutoSearchClick(_ sender: Any) {
        
        isPlaceTitle = true
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
        
    }
   
    @IBAction func btn350mClick(_ sender: Any) {
        userBoundarySize = "350 m"
        isButtonClicked = true
        imgPinCenter.image = #imageLiteral(resourceName: "safeArea")
        btn350m.backgroundColor = planoColor
        btn350m.setTitleColor(UIColor.white, for: UIControlState.normal)
        
        btn550m.backgroundColor = UIColor.white
        btn550m.setTitleColor(planoColor, for: UIControlState.normal)
        
        btnOneK.backgroundColor = UIColor.white
        btnOneK.setTitleColor(planoColor, for: UIControlState.normal)
        
        currentZoom = 15;
        addGMSCameraPosition(mapPostion.target.latitude, mapPostion.target.longitude , currentZoom)
    }
    

    @IBAction func btn550mClick(_ sender: Any) {
       userBoundarySize = "550 m"
        imgPinCenter.image = #imageLiteral(resourceName: "safeArea")
        isButtonClicked = true
        btn550m.backgroundColor = planoColor
        btn550m.setTitleColor(UIColor.white, for: UIControlState.normal)
        
        btn350m.backgroundColor = UIColor.white
        btn350m.setTitleColor(planoColor, for: UIControlState.normal)
        
        btnOneK.backgroundColor = UIColor.white
        btnOneK.setTitleColor(planoColor, for: UIControlState.normal)
        currentZoom = 14;
        
        addGMSCameraPosition(mapPostion.target.latitude, mapPostion.target.longitude , currentZoom)
        
    }
    
    @IBAction func btnOneKClick(_ sender: Any) {
        userBoundarySize = "1 km"
        isButtonClicked = true
        btnOneK.backgroundColor = planoColor
        btnOneK.setTitleColor(UIColor.white, for: UIControlState.normal)
        
        btn550m.backgroundColor = UIColor.white
        btn550m.setTitleColor(planoColor, for: UIControlState.normal)
        
        btn350m.backgroundColor = UIColor.white
        btn350m.setTitleColor(planoColor, for: UIControlState.normal)
       
        imgPinCenter.image = #imageLiteral(resourceName: "safeArea")
        currentZoom = 13;
        addGMSCameraPosition(mapPostion.target.latitude, mapPostion.target.longitude , currentZoom)
    }
    
    @IBAction func btnSave(_ sender: Any){
//        CLLocationCoordinate2D,_ placeID:String,_ Address:String,_ description:String ,  _ boundarySize:String
        if(mapdelegate != nil){
            mapdelegate?.didRecieveMapData("TestName", mapPostion.target , userPlace.placeID, userPlace.formattedAddress!, userPlace.description,userBoundarySize,"")
//       _ boundaryName:String,_ userMapPosition : CLLocationCoordinate2D,_ placeID:String,_ Address:String,_ AddressTitle:String ,_ description:String , _ boundarySize:String
           self.navigationController?.popViewController(animated: true)
            
        }
//    self.navigationController?.popViewController(animated: true)
       
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
        mapView.clear()
        markerLocation?.map = mapView
       
    }
   
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
       
        self.getAddressForMapCenter()
        mapView.settings.zoomGestures = false
        mapView.settings.rotateGestures = false
        getplaceID()
        mapPostion = GMSCameraPosition(target: position.target, zoom: currentZoom, bearing: 0, viewingAngle: 0)
//        print("Place ID \(mapPostion.)")
        addGMSCameraPosition(mapPostion.target.latitude, mapPostion.target.longitude , currentZoom)
  
    }
    
    func mapView(mapView: GMSMapView!, didChangeCameraPosition position: GMSCameraPosition!) {
        print("\(position.target.latitude) \(position.target.longitude)")
//        markerLocation.position = position.target
    }
 
    
}

extension ChildrenLocationVC: CLLocationManagerDelegate {
    
    func locationManager( _ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations.first {

            mapPostion = GMSCameraPosition(target: location.coordinate, zoom: currentZoom, bearing: 0, viewingAngle: 0)
            
            
            addGMSCameraPosition(location.coordinate.latitude, location.coordinate.longitude , currentZoom)
            
//            let overlay = GMSGroundOverlay(position: location.coordinate, icon: #imageLiteral(resourceName: "iconPin"), zoomLevel: 15)
//            overlay.map = mapView
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
    
}
extension ChildrenLocationVC: GMSAutocompleteViewControllerDelegate {
       // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        print("Place\(place.placeID)")
        dismiss(animated: true, completion: nil)
        
        self.lblLocationTitle.text = place.name
        self.lblLocationAddress.text = place.formattedAddress
        
        if(isPlaceTitle == true){
            tempLbl = place.name
        }
        print("\(self.lblLocationTitle.text)")
        
        mapPostion = GMSCameraPosition(target: place.coordinate , zoom: currentZoom, bearing: 0, viewingAngle: 0)
        addGMSCameraPosition(mapPostion.target.latitude, mapPostion.target.longitude , currentZoom)

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
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        print("ksjalfsjkdf")
    }
}
