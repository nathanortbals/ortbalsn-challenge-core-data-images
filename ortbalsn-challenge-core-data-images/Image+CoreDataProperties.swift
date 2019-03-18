//
//  Image+CoreDataProperties.swift
//  ortbalsn-challenge-core-data-images
//
//  Created by Nathan Ortbals on 3/18/19.
//  Copyright © 2019 Nathan Ortbals. All rights reserved.
//
//

import Foundation
import CoreData


extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image")
    }

    @NSManaged public var title: String?
    @NSManaged public var rawDateModified: NSDate?
    @NSManaged public var rawImage: NSData?

}
