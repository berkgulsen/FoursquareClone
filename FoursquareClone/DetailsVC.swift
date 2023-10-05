//
//  detailsVC.swift
//  FoursquareClone
//
//  Created by Berk Gülşen on 2.10.2023.
//

import UIKit
import MapKit
import Parse

class DetailsVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var detailsImageView: UIImageView!
    @IBOutlet weak var detailsNameLabel: UILabel!
    @IBOutlet weak var detailsTypeLabel: UILabel!
    @IBOutlet weak var detailsAtmosphereLabel: UILabel!
    @IBOutlet weak var detailsMapView: MKMapView!
    
    
    var choosenPlaceId = ""
    var choosenLongitude = Double()
    var choosenLatitude = Double()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        getDataFromParse()
        
        detailsMapView.delegate = self
    }
    
    func getDataFromParse() {
        let query = PFQuery(className: "Places")
        query.whereKey("objectId", equalTo: choosenPlaceId)
        query.findObjectsInBackground { objects, error in
            if error != nil {
                
            } else {
                if objects != nil {
                    if objects!.count > 0 {
                        let choosenPlaceOnject = objects![0]
                        
                        
                        if let placeName = choosenPlaceOnject.object(forKey: "name") as? String{
                            self.detailsNameLabel.text = placeName
                        }
                        if let placeType = choosenPlaceOnject.object(forKey: "type") as? String{
                            self.detailsTypeLabel.text = placeType
                        }
                        if let placeAtmosphere = choosenPlaceOnject.object(forKey: "atmosphere") as? String{
                            self.detailsAtmosphereLabel.text = placeAtmosphere
                        }
                        if let placeLatitude = choosenPlaceOnject.object(forKey: "latitude") as? String {
                            if let placeLatitudeDouble = Double(placeLatitude) {
                                self.choosenLatitude = placeLatitudeDouble
                            }
                        }
                        if let placeLongitude = choosenPlaceOnject.object(forKey: "longitude") as? String {
                            if let placeLongitudeDouble = Double(placeLongitude) {
                                self.choosenLongitude = placeLongitudeDouble
                            }
                        }
                        if let imageData = choosenPlaceOnject.object(forKey: "image") as? PFFileObject {
                            imageData.getDataInBackground { data, error in
                                if error == nil {
                                    if data != nil {
                                        self.detailsImageView.image = UIImage(data: data!)
                                    }
                                }
                            }
                        }
                        
                        
                        let locationCoordinate = CLLocationCoordinate2D(latitude: self.choosenLatitude, longitude: self.choosenLongitude)
                                        
                        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                        let region = MKCoordinateRegion(center: locationCoordinate, span: span)
                        self.detailsMapView.setRegion(region, animated: true)
                                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = locationCoordinate
                        annotation.title = self.detailsNameLabel.text
                        annotation.subtitle = self.detailsTypeLabel.text
                        self.detailsMapView.addAnnotation(annotation)
                                    
                    }
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            let button = UIButton(type: UIButton.ButtonType.detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
        } else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.choosenLatitude != 0.0, self.choosenLongitude != 0.0 {
            let requestLocation = CLLocation(latitude: self.choosenLatitude, longitude: self.choosenLongitude)
            
            CLGeocoder().reverseGeocodeLocation(requestLocation) { placemarks, error in
                if let placemark = placemarks {
                    if placemark.count > 0 {
                        let mkPlacemark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mkPlacemark)
                        mapItem.name = self.detailsNameLabel.text
                        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
                    }
                }
            }
        }
    }
}
