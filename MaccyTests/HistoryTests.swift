import XCTest
@testable import Maccy

class HistoryTests: XCTestCase {
  let savedIgnoreEvents = UserDefaults.standard.ignoreEvents
  let savedSize = UserDefaults.standard.size
  let history = History()

  var savedStorage: [HistoryItem] = []

  override func setUp() {
    super.setUp()
    UserDefaults.standard.ignoreEvents = false
    UserDefaults.standard.size = 10
//    savedStorage = history.all
    history.clear()

//    let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
//    let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
//    try! persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
//    CoreDataManager.shared.persistentContainer.persistentStoreCoordinator = persistentStoreCoordinator

//    UserDefaults.standard.storage = []
  }

  override func tearDown() {
    super.tearDown()
    UserDefaults.standard.ignoreEvents = savedIgnoreEvents
    UserDefaults.standard.size = savedSize
    history.clear()
    savedStorage.forEach(history.add(_:))
    savedStorage = []
//    UserDefaults.standard.storage = savedStorage
  }

  func testDefaultIsEmpty() {
    XCTAssertEqual(history.all, [])
  }

  func testAdding() {
    let first = historyItem("foo")
    let second = historyItem("bar")
    history.add(first)
    history.add(second)
    XCTAssertEqual(history.all, [first, second])
  }

  func testAddingSame() {
    let first = historyItem("foo")
    let second = historyItem("bar")
    let third = historyItem("foo")
    history.add(first)
    history.add(second)
    history.add(third)
    XCTAssertEqual(history.all, [first, second])
//    XCTAssertTrue(history.all[0].lastCopiedAt > history.all[0].firstCopiedAt)
//    XCTAssertEqual(history.all[0].numberOfCopies, 2)
  }

//  func testAddingBlank() {
//    history.add(historyItem(" "))
//    history.add(historyItem("\n"))
//    history.add(historyItem(" foo"))
//    history.add(historyItem("\n bar"))
//    XCTAssertEqual(history.all, [historyItem("\n bar"), historyItem(" foo")])
//  }
//
//  func testIgnore() {
//    UserDefaults.standard.set(true, forKey: "ignoreEvents")
//    history.add(historyItem("foo"))
//    XCTAssertEqual(history.all, [])
//  }
//
//  func testUpdate() {
//    history.add(historyItem("foo"))
//    let historyItem = history.all[0]
//
//    historyItem.numberOfCopies = 0
//    XCTAssertEqual(history.all[0].numberOfCopies, 1)
//
//    history.update(historyItem)
//    XCTAssertEqual(history.all[0].numberOfCopies, 0)
//  }
//
//  func testClearing() {
//    history.add(historyItem("foo"))
//    history.clear()
//    XCTAssertEqual(history.all, [])
//  }
//
//  func testMaxSize() {
//    for index in 0...10 {
//      history.add(historyItem(String(index)))
//    }
//
//    XCTAssertEqual(history.all.count, 10)
//    XCTAssertTrue(history.all.contains(historyItem("10")))
//    XCTAssertFalse(history.all.contains(historyItem("0")))
//  }
//
//  func testMaxSizeIsChanged() {
//    for index in 0...10 {
//      history.add(historyItem(String(index)))
//    }
//    UserDefaults.standard.size = 5
//
//    XCTAssertEqual(history.all.count, 5)
//    XCTAssertTrue(history.all.contains(historyItem("10")))
//    XCTAssertFalse(history.all.contains(historyItem("5")))
//  }
//
//  func testRemoving() {
//    history.add(historyItem("foo"))
//    history.add(historyItem("bar"))
//    history.remove(historyItem("foo"))
//    XCTAssertEqual(history.all, [historyItem("bar")])
//  }
//
  private func historyItem(_ value: String) -> HistoryItem {
    let content = HistoryItemContent(type: NSPasteboard.PasteboardType.string.rawValue,
                                     value: value.data(using: .utf8)!)
    let item = HistoryItem(contents: [content])
    return item
  }
//
//  private func historyItem(_ value: NSImage) -> HistoryItem {
//    let item = HistoryItem(value: value.tiffRepresentation!)
//    item.type = .image
//    return item
//  }
}
