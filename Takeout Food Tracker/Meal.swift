//
//  Meal.swift
//  Takeout Food Tracker
//
//  Created by George on 31/12/2019.
//  Copyright © 2019 George. All rights reserved.
//

import UIKit
import os.log

class Meal: NSObject, NSCoding {
    
    //MARK: Properties
    var mealName: String
    var companyName: String
    var price: Double
    var dateTime: String
    var photo: UIImage?
    var rating: Int
    var notes: String
        
    //MARK: Archiving Paths
     
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
    
    //MARK: Types
     
    struct PropertyKey {
        static let mealName = "mealName"
        static let companyName = "companyName"
        static let price = "price"
        static let dateTime = "dateTime"
        static let photo = "photo"
        static let rating = "rating"
        static let notes = "notes"
    }
    
    //MARK: Initialization
    init?(mealName: String, companyName: String, price: Double, dateTime: String, photo: UIImage?, rating: Int, notes: String) {
        
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
        self.notes = notes
    }

    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(mealName, forKey: PropertyKey.mealName)
        aCoder.encode(companyName, forKey: PropertyKey.companyName)
        aCoder.encode(price, forKey: PropertyKey.price)
        aCoder.encode(dateTime, forKey: PropertyKey.dateTime)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
        aCoder.encode(notes, forKey: PropertyKey.notes)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let mealName = aDecoder.decodeObject(forKey: PropertyKey.mealName) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
       guard let companyName = aDecoder.decodeObject(forKey: PropertyKey.companyName) as? String else {
            os_log("Unable to decode the name for a Company object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let price = aDecoder.decodeDouble(forKey: PropertyKey.price)
        
        guard let dateTime = aDecoder.decodeObject(forKey: PropertyKey.dateTime) as? String else {
            os_log("Unable to decode the date for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }

        // Because photo is an optional property of Meal, just use conditional cast.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        
        guard let notes = aDecoder.decodeObject(forKey: PropertyKey.notes) as? String else {
            os_log("Unable to decode the notes for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(mealName: mealName, companyName: companyName, price: price, dateTime: dateTime, photo: photo, rating: rating, notes: notes)
    }
}

