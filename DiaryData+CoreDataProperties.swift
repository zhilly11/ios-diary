//
//  DiaryData+CoreDataProperties.swift
//  Diary
//
//  Created by 최지혁 on 2022/12/24.
//
//

import Foundation
import CoreData


extension DiaryData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiaryData> {
        return NSFetchRequest<DiaryData>(entityName: "DiaryData")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var title: String?
    @NSManaged public var body: String?

}

extension DiaryData : Identifiable {

}
