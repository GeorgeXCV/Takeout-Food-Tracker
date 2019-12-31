//
//  Meal.swift
//  Takeout Food Tracker
//
//  Created by George on 31/12/2019.
//  Copyright © 2019 George. All rights reserved.
//

import UIKit

class Meal {
    var mealName: String
    var companyName: String
    var price: Double
    var dateTime: String
    var photo: UIImage?
    var rating: Int
    
    

    //MARK: Initialization
    init?(mealName: String, companyName: String, price: Double, dateTime: String, photo: UIImage?, rating: Int) {
        
        // Initialization should fail if there is no name or if the rating is negative.
        if mealName.isEmpty || rating < 0  {
            return nil
        }
        
        self.mealName = mealName
        self.companyName = companyName
        self.price = price
        self.dateTime = dateTime
        self.photo = photo
        self.rating = rating
    }


}

