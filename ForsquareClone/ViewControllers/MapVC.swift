//
//  MapVC.swift
//  ForsquareClone
//
//  Created by Arif TABAKOĞLU on 23.09.2022.
//

import UIKit
import MapKit
import Parse

class MapVC: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate{

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Add on info.plist -> Privacy - Location When in
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        recognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(recognizer)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        //locationManager.stopUpdatingLocation() Yer değişikliğinde eski konuma zoomlarsa diye bunu yapıyoruz.
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
    }
    
    @objc func chooseLocation(gestureRecognizer:UIGestureRecognizer){
        
        if gestureRecognizer.state == UIGestureRecognizer.State.began{
            
            let touches = gestureRecognizer.location(in: self.mapView)
            let coordinates = self.mapView.convert(touches, toCoordinateFrom: self.mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = PlaceModel.sharedInstance.placeName
            annotation.subtitle = PlaceModel.sharedInstance.placeType
            
            self.mapView.addAnnotation(annotation)
            
            PlaceModel.sharedInstance.placeLatitude = String(coordinates.latitude)
            PlaceModel.sharedInstance.placeLongtitude = String(coordinates.longitude)
        }
        
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        
        self.dismiss(animated: true)
        
    }
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        let placesModel = PlaceModel.sharedInstance
        
        let parseObject = PFObject(className: "Places")
        parseObject["name"] = placesModel.placeName
        parseObject["type"] = placesModel.placeType
        parseObject["atmosphere"] = placesModel.placeAtmosphere
        parseObject["latitude"] = placesModel.placeLatitude
        parseObject["longtitude"] = placesModel.placeLongtitude
        
        if let imageData = placesModel.placeImage.jpegData(compressionQuality: 0.5){
            
            parseObject["image"] = PFFileObject(name: "image.jpeg", data: imageData)
            
        }
        
        parseObject.saveInBackground { success, error in
            
            if error != nil {
                
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive)
                
                alertController.addAction(okButton)
                self.present(alertController, animated: true)
                
            }else{
                self.performSegue(withIdentifier: "fromMapVCtoPlacesVC", sender: nil)
            }
        }
    }

    
    
}



