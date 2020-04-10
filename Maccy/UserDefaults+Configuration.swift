import Foundation

extension UserDefaults {
  public struct Keys {
    static let fuzzySearch = "fuzzySearch"
    static let hideFooter = "hideFooter"
    static let hideSearch = "hideSearch"
    static let hideTitle = "hideTitle"
    static let hotKey = "hotKey"
    static let ignoreEvents = "ignoreEvents"
    static let imageMaxHeight = "imageMaxHeight"
    static let migrations = "migrations"
    static let pasteByDefault = "pasteByDefault"
    static let popupPosition = "popupPosition"
    static let saratovSeparator = "enableSaratovSeparator"
    static let size = "historySize"
    static let sortBy = "sortBy"

    static var showInStatusBar: String {
      ProcessInfo.processInfo.arguments.contains("ui-testing") ? "showInStatusBarUITests" : "showInStatusBar"
    }
  }

  public struct Values {
    static let hotKey = "command+shift+c"
    static let imageMaxHeight = 40.0
    static let migrations: [String: Bool] = [:]
    static let popupPosition = "cursor"
    static let showInStatusBar = true
    static let size = 200
    static let sortBy = "lastCopiedAt"
  }

  public var fuzzySearch: Bool {
    get { ProcessInfo.processInfo.arguments.contains("ui-testing") ? false : bool(forKey: Keys.fuzzySearch) }
    set { set(newValue, forKey: Keys.fuzzySearch) }
  }

  @objc dynamic public var hideFooter: Bool {
    get { bool(forKey: Keys.hideFooter) }
    set { set(newValue, forKey: Keys.hideFooter) }
  }

  @objc dynamic public var hideSearch: Bool {
    get { bool(forKey: Keys.hideSearch) }
    set { set(newValue, forKey: Keys.hideSearch) }
  }

  @objc dynamic public var hideTitle: Bool {
    get { bool(forKey: Keys.hideTitle) }
    set { set(newValue, forKey: Keys.hideTitle) }
  }

  @objc dynamic public var hotKey: String {
    get { string(forKey: Keys.hotKey) ?? Values.hotKey }
    set { set(newValue, forKey: Keys.hotKey) }
  }

  public var ignoreEvents: Bool {
    get { bool(forKey: Keys.ignoreEvents) }
    set { set(newValue, forKey: Keys.ignoreEvents) }
  }

  public var imageMaxHeight: Float {
    get { float(forKey: Keys.imageMaxHeight) }
    set { set(newValue, forKey: Keys.imageMaxHeight) }
  }

  public var migrations: [String: Bool] {
    get { dictionary(forKey: Keys.migrations) as? [String: Bool] ?? Values.migrations }
    set { set(newValue, forKey: Keys.migrations) }
  }

  @objc dynamic public var pasteByDefault: Bool {
    get { bool(forKey: Keys.pasteByDefault) }
    set { set(newValue, forKey: Keys.pasteByDefault) }
  }

  public var popupPosition: String {
    get { string(forKey: Keys.popupPosition) ?? Values.popupPosition }
    set { set(newValue, forKey: Keys.popupPosition) }
  }

  public var saratovSeparator: Bool {
    get { bool(forKey: Keys.saratovSeparator) }
    set { set(newValue, forKey: Keys.saratovSeparator) }
  }

  @objc dynamic public var showInStatusBar: Bool {
    get { ProcessInfo.processInfo.arguments.contains("ui-testing") ? true : bool(forKey: Keys.showInStatusBar) }
    set { set(newValue, forKey: Keys.showInStatusBar) }
  }

  public var size: Int {
    get { integer(forKey: Keys.size) }
    set { set(newValue, forKey: Keys.size) }
  }

  public var sortBy: String {
    get { string(forKey: Keys.sortBy) ?? Values.sortBy }
    set { set(newValue, forKey: Keys.sortBy) }
  }
}
