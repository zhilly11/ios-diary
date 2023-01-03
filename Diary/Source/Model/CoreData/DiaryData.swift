//  Diary - DiaryData.swift
//  Created by Ayaan, zhilly on 2022/12/26

import CoreData

@objc(DiaryData)
final class DiaryData: NSManagedObject {
    @NSManaged public var content: String
    @NSManaged public var createdAt: Date
    @NSManaged public var weatherCondition: String?
    @NSManaged public var weatherIconID: String?
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiaryData> {
        return NSFetchRequest<DiaryData>(entityName: "DiaryData")
    }
}
