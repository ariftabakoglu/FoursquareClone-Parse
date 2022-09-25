//
//  PlaceModel.swift
//  ForsquareClone
//
//  Created by Arif TABAKOĞLU on 23.09.2022.
//

import Foundation
import UIKit

class PlaceModel{
    
    static let sharedInstance = PlaceModel()
    
    var placeName = ""
    var placeType = ""
    var placeAtmosphere = ""
    var placeImage = UIImage()
    var placeLatitude = ""
    var placeLongtitude = "" 
    
    private init(){
        
    }
    
}
