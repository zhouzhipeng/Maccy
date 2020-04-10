import CoreData

class CoreDataManager {
  static public let shared = CoreDataManager()

  public var viewContext: NSManagedObjectContext {
    return CoreDataManager.shared.persistentContainer.viewContext
  }

  lazy public var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "Storage")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()

  lazy public var memoryContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "Storage")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()


  private init() {}

  func saveContext() {
    let context = CoreDataManager.shared.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
}
