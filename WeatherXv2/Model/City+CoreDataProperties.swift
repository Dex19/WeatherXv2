//
//  City+CoreDataProperties.swift
//  City
//
//  Created by Tino on 16.08.2021..
//
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var name: String?
    @NSManaged public var country: String?
    @NSManaged public var id: Int64
    @NSManaged public var forecasts: NSSet?

}

// MARK: Generated accessors for forecasts
extension City {

    @objc(addForecastsObject:)
    @NSManaged public func addToForecasts(_ value: Weather)

    @objc(removeForecastsObject:)
    @NSManaged public func removeFromForecasts(_ value: Weather)

    @objc(addForecasts:)
    @NSManaged public func addToForecasts(_ values: NSSet)

    @objc(removeForecasts:)
    @NSManaged public func removeFromForecasts(_ values: NSSet)

}

extension City : Identifiable {

}
