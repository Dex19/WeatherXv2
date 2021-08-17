//
//  Weather+CoreDataProperties.swift
//  Weather
//
//  Created by Tino on 16.08.2021..
//
//

import Foundation
import CoreData


extension Weather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Weather> {
        return NSFetchRequest<Weather>(entityName: "Weather")
    }

    @NSManaged public var date: Date?
    @NSManaged public var temp: String?
    @NSManaged public var weather: String?
    @NSManaged public var image: String?
    @NSManaged public var desc: String?
    @NSManaged public var city: City?

}

extension Weather : Identifiable {

}
