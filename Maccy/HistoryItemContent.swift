import CoreData

@objc(HistoryItemContent)
class HistoryItemContent: NSManagedObject {
  @NSManaged public var type: String!
  @NSManaged public var value: Data!
  @NSManaged public var item: HistoryItem?

  @nonobjc
  public class func fetchRequest() -> NSFetchRequest<HistoryItemContent> {
    return NSFetchRequest<HistoryItemContent>(entityName: "HistoryItemContent")
  }

  public static func == (lhs: HistoryItemContent, rhs: HistoryItemContent) -> Bool {
    return (lhs.type == rhs.type) && (lhs.value == rhs.value)
  }

  convenience init(type: String, value: Data) {
    let historyItemContentEntity = NSEntityDescription.entity(forEntityName: "HistoryItemContent", in: CoreDataManager.shared.viewContext)!
    self.init(entity: historyItemContentEntity, insertInto: CoreDataManager.shared.viewContext)

    self.type = type
    self.value = value
  }
}
