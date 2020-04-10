import AppKit

class History {
  public var all: [HistoryItem] {
    let fetchRequest = NSFetchRequest<HistoryItem>(entityName: "HistoryItem")
    var items = try! CoreDataManager.shared.viewContext.fetch(fetchRequest)

    while items.count > UserDefaults.standard.size {
      remove(items.removeLast())
    }

    return items
  }

  init() {
    UserDefaults.standard.register(defaults: [UserDefaults.Keys.size: UserDefaults.Values.size])
    if ProcessInfo.processInfo.arguments.contains("ui-testing") {
      clear()
    }
  }

  func add(_ typesWithData: [NSPasteboard.PasteboardType: Data]) {
    if UserDefaults.standard.ignoreEvents {
      return
    }

//    if item.type == .string, let string = String(data: item.value, encoding: .utf8) {
//      if string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
//        return
//      }
//    }

    if let existingHistoryItem = all.first(where: { $0 == item }) {
      item.firstCopiedAt = existingHistoryItem.firstCopiedAt
      item.numberOfCopies += existingHistoryItem.numberOfCopies
      existingHistoryItem.

      remove(existingHistoryItem)
    }
  }

//  func update(_ item: HistoryItem) {
//    CoreDataManager.shared.saveContext()
//  }

  func remove(_ item: HistoryItem) {
    CoreDataManager.shared.viewContext.delete(item)
  }

  func clear() {
    all.forEach(remove(_:))
  }
}
