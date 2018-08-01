//
//  CropProfileCore+CoreDataProperties.swift
//  
//
//  Created by Bowen He on 2018-07-30.
//
//

import Foundation
import CoreData


extension CropProfileCore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CropProfileCore> {
        return NSFetchRequest<CropProfileCore>(entityName: "CropProfileCore")
    }

    @NSManaged public var cropName: String?
    @NSManaged public var plotLength: Double
    @NSManaged public var plotWidth: Double
    @NSManaged public var profName: String?
    @NSManaged public var isOnline: Bool

}
