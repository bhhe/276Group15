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
    @NSManaged public var plotLength: Int16
    @NSManaged public var plotWidth: Int16
    @NSManaged public var profName: String?
    @NSManaged public var isOnline: Bool

}
