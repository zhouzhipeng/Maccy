import CoreData

@objc(HistoryItem)
class HistoryItem: NSManagedObject {
  @NSManaged public var contents: NSSet?
  @NSManaged public var firstCopiedAt: Date!
  @NSManaged public var lastCopiedAt: Date!
  @NSManaged public var numberOfCopies: Int64
  @NSManaged public var pin: String?

  @objc(addContentsObject:)
  @NSManaged public func addToContents(_ value: HistoryItemContent)

  @nonobjc
  public class func fetchRequest() -> NSFetchRequest<HistoryItem> {
    return NSFetchRequest<HistoryItem>(entityName: "HistoryItem")
  }

  public static func == (lhs: HistoryItem, rhs: HistoryItem) -> Bool {
    let lhsContents = lhs.contents?.allObjects as! [HistoryItemContent]
    let rhsContents = lhs.contents?.allObjects as! [HistoryItemContent]
    return lhsContents == rhsContents
  }

  convenience init(contents: [HistoryItemContent]) {
    let historyItemEntity = NSEntityDescription.entity(forEntityName: "HistoryItem", in: CoreDataManager.shared.viewContext)!
    self.init(entity: historyItemEntity, insertInto: CoreDataManager.shared.viewContext)

    self.firstCopiedAt = Date()
    self.lastCopiedAt = firstCopiedAt
    self.numberOfCopies = 1

    contents.forEach(addToContents(_:))
  }
}
