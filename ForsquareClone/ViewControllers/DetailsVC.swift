//
//  DetailsVC.swift
//  ForsquareClone
//
//  Created by Arif TABAKOĞLU on 23.09.2022.
//

import UIKit
import MapKit
import Parse

class DetailsVC: UIViewController {
    
    @IBOutlet weak var detailsMapView: MKMapView!
    @IBOutlet weak var detailsImageView: UIImageView!
    @IBOutlet weak var detailsNameLabel: UILabel!
    @IBOutlet weak var detailsTypeLabel: UILabel!
    @IBOutlet weak var detailsAtmosphereLabel: UILabel!
    
    var choosenPlaceId = ""
    var choosenLatitude = Double()
    var choosenLongitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsMapView.delegate = self
        
        getDataFromParse()
        
        
        
    }
    
    
    func getDataFromParse(){
        
        let query = PFQuery(className: "Places")
        query.whereKey("objectId", equalTo: choosenPlaceId)
        query.findObjectsInBackground { objects, error in
            if error != nil {
                
                
            }else{
                
                if objects != nil{
                    if objects!.count > 0 {
                        let choosenPlaceObject = objects![0]
                        
                        // Objects
                        
                        if let placeName = choosenPlaceObject.object(forKey: "name") as? String{
                            self.detailsNameLabel.text = placeName
                        }
                        
                        if let placeType = choosenPlaceObject.object(forKey: "type") as? String{
                            self.detailsTypeLabel.text = placeType
                        }
                        
                        if let placeAtmosphere = choosenPlaceObject.object(forKey: "atmosphere") as? String{
                            self.detailsAtmosphereLabel.text = placeAtmosphere
                        }
                        
                        if let placeLatitude = choosenPlaceObject.object(forKey: "latitude") as? String{
                            if let placeLatitudeDouble = Double(placeLatitude){
                                self.choosenLatitude = placeLatitudeDouble
                            }
                        }
                        
                        if let placeLongitude = choosenPlaceObject.object(forKey: "longtitude") as? String{
                            if let placeLongitudeDouble = Double(placeLongitude){
                                self.choosenLongitude = placeLongitudeDouble
                                
                            }
                        }
                        
                        if let imageData = choosenPlaceObject.object(forKey: "image") as? PFFileObject{
                            imageData.getDataInBackground { data, error in
                                if error == nil{
                                    if data != nil {
                                        self.detailsImageView.image = UIImage(data: data!)
                                    }
                                }
                            }
                        }
                        
                        
                        // Maps
                        
                        let location = CLLocationCoordinate2D(latitude: self.choosenLatitude, longitude: self.choosenLongitude)
                        
                        let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
                        
                        let region = MKCoordinateRegion(center: location, span: span)
                        
                        self.detailsMapView.setRegion(region, animated: true)
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = location
                        annotation.title = self.detailsNameLabel.text!
                        annotation.subtitle = self.detailsTypeLabel.text!
                        self.detailsMapView.addAnnotation(annotation)
                        
                        
                    }
                    
                }
                
            }
        }
    }
    
    @IBAction func backButonClicked(_ sender: Any) {
        
        self.dismiss(animated: true)
        
    }
}

extension DetailsVC : MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
        if annotation is MKUserLocation{
            return nil
        }
        
        let reuseID = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        
        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
            
        }else{
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if self.choosenLongitude != 0.0 && self.choosenLatitude != 0.0 {
            
            let requestLocation = CLLocation(latitude: self.choosenLatitude, longitude: self.choosenLongitude)
            
            CLGeocoder().reverseGeocodeLocation(requestLocation) { placeMarks, error in
                if let placeMark = placeMarks{
                    
                    if placeMark.count > 0 {
                        
                        let mkPlaceMark = MKPlacemark(placemark:placeMark[0])
                        let mapItem = MKMapItem(placemark: mkPlaceMark)
                        mapItem.name = self.detailsNameLabel.text
                        
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                        
                        mapItem.openInMaps(launchOptions: launchOptions)
                        
                    }
                    
                }
            }
            
        }
        
        
    }
    
}
