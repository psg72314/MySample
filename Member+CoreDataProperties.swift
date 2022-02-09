//
//  Member+CoreDataProperties.swift
//  
//
//  Created by SCpeng on 2022/1/13.
//
//

import Foundation
import CoreData


extension Member {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Member> {
        return NSFetchRequest<Member>(entityName: "Member")
    }

    @NSManaged public var department: String
    @NSManaged public var id: Int32?
    @NSManaged public var name: String?

}
