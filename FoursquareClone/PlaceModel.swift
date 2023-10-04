//
//  PlaceModel.swift
//  FoursquareClone
//
//  Created by Berk Gülşen on 3.10.2023.
//

import Foundation
import UIKit

class PlaceModel {
    static let sharedInstance = PlaceModel()
    
    var placeName = ""
    var placeType = ""
    var placeAtmosphere = ""
    var placeImage = UIImage()
    var placeLongitude = ""
    var placeLatitude = ""
    
    private init(){
        
    }
    
}
