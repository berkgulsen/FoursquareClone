//
//  detailsVC.swift
//  FoursquareClone
//
//  Created by Berk Gülşen on 2.10.2023.
//

import UIKit
import MapKit
import Parse

class DetailsVC: UIViewController {
    @IBOutlet weak var detailsImageView: UIImageView!
    @IBOutlet weak var detailsNameLabel: UILabel!
    @IBOutlet weak var detailsTypeLabel: UILabel!
    @IBOutlet weak var detailsAtmosphereLabel: UILabel!
    
    var choosenPlaceId = ""
    
    var choosenLongitude = Double()
    var choosenLatitude = Double()
    
    @IBOutlet weak var detailsMapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        getDataFromParse()
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
                                        print("image printed")
                                    }
                                }
                            }
                        }
                        
                    }
                }
            }
        }
    }
}
