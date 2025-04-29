//
//  ManagedFeedItem.swift
//  InstagramFeedClone
//
//  Created by Mohamed Afsal on 28/04/2025.
//

import CoreData

@objc(ManagedFeedItem)
class ManagedFeedItem: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var url: URL
    @NSManaged var type: String
    @NSManaged var data: Data?
}

extension ManagedFeedItem {
    static func first(with url: URL, in context: NSManagedObjectContext) throws -> ManagedFeedItem? {
      let request = NSFetchRequest<ManagedFeedItem>(entityName: entity().name!)
      request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(ManagedFeedItem.url), url])
      request.returnsObjectsAsFaults = false
      request.fetchLimit = 1
      return try context.fetch(request).first
    }

    static func images(from feed: [LocalFeedItem], in context: NSManagedObjectContext) -> NSOrderedSet {
        return NSOrderedSet(array: feed.map { local in
            let managed = ManagedFeedItem(context: context)
            managed.id = local.id
            managed.type = local.type.rawValue
            managed.url = local.url
            return managed
        })
    }
    
    var local: LocalFeedItem {
        let mediaType = MediaType(rawValue: type) ?? .unknown
        return LocalFeedItem(id: id, type: mediaType, url: url)
    }
}
