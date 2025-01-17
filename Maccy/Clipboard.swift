import AppKit
import Carbon

class Clipboard {
  typealias OnNewCopyHook = (HistoryItem) -> Void

  private let pasteboard = NSPasteboard.general
  private let timerInterval = 1.0

  // See http://nspasteboard.org for more details.
  private let ignoredTypes: Set = [
    "org.nspasteboard.TransientType",
    "org.nspasteboard.ConcealedType",
    "org.nspasteboard.AutoGeneratedType",
    "de.petermaurer.TransientPasteboardType",
    "com.typeit4me.clipping",
    "Pasteboard generator type",
    "com.agilebits.onepassword"
  ]

  private var changeCount: Int
  private var onNewCopyHooks: [OnNewCopyHook]

  init() {
    changeCount = pasteboard.changeCount
    onNewCopyHooks = []
  }

  func onNewCopy(_ hook: @escaping OnNewCopyHook) {
    onNewCopyHooks.append(hook)
  }

  func startListening() {
    Timer.scheduledTimer(timeInterval: timerInterval,
                         target: self,
                         selector: #selector(checkForChangesInPasteboard),
                         userInfo: nil,
                         repeats: true)
  }

  func copy(_ data: Data, _ type: NSPasteboard.PasteboardType) {
    pasteboard.declareTypes([type], owner: nil)
    pasteboard.setData(data, forType: type)
  }

  // Based on https://github.com/Clipy/Clipy/blob/develop/Clipy/Sources/Services/PasteService.swift.
  func paste() {
    checkAccessibilityPermissions()

    DispatchQueue.main.async {
      let vCode = UInt16(kVK_ANSI_V)
      let source = CGEventSource(stateID: .combinedSessionState)
      // Disable local keyboard events while pasting
      source?.setLocalEventsFilterDuringSuppressionState([.permitLocalMouseEvents, .permitSystemDefinedEvents],
                                                         state: .eventSuppressionStateSuppressionInterval)

      let keyVDown = CGEvent(keyboardEventSource: source, virtualKey: vCode, keyDown: true)
      let keyVUp = CGEvent(keyboardEventSource: source, virtualKey: vCode, keyDown: false)
      keyVDown?.flags = .maskCommand
      keyVUp?.flags = .maskCommand
      keyVDown?.post(tap: .cgAnnotatedSessionEventTap)
      keyVUp?.post(tap: .cgAnnotatedSessionEventTap)
    }
  }

  @objc
  func checkForChangesInPasteboard() {
    guard pasteboard.changeCount != changeCount else {
      return
    }

    // Some applications add 2 items to pasteboard when copying:
    //   1. The proper meaningful string.
    //   2. The empty item with no data and types.
    // An example of such application is BBEdit.
    // To handle such cases, handle all new pasteboard items,
    // not only the last one.
    // See https://github.com/p0deje/Maccy/issues/78.
    pasteboard.pasteboardItems?.forEach({ item in
      if !shouldIgnore(item.types) {
        if item.types.contains(.tiff) {
          if let data = item.data(forType: .tiff) {
            let historyItem = HistoryItem(value: data)
            historyItem.type = .image
            onNewCopyHooks.forEach({ $0(historyItem) })
          }
        } else {
          if let data = item.data(forType: .string) {
            let title = String(data: data, encoding: .utf8)!
            
            let historyItem = HistoryItem(value: data)
            historyItem.type = .string
            onNewCopyHooks.forEach({ $0(historyItem) })

            // long型的timestamp 转为 Date string 放在顶部
            if isTimeStamp(str: title){
              let number: Double! = Double(title)

              let dateStr: Data! = timeIntervalChangeToTimeStr(timeInterval: number, dateFormat: nil).data(using: .utf8)
              let historyItem2 = HistoryItem(value: dateStr)
              historyItem2.type = .string
              onNewCopyHooks.forEach({ $0(historyItem2) })

            }
            
            
         
            
          }
        }
      }
    })

    changeCount = pasteboard.changeCount
  }

  //时间戳转成字符串
  func timeIntervalChangeToTimeStr(timeInterval:Double, dateFormat:String?) -> String {
    let date:NSDate = NSDate.init(timeIntervalSince1970: timeInterval/1000)
    let formatter = DateFormatter.init()
    if dateFormat == nil {
      formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }else{
      formatter.dateFormat = dateFormat
    }
    return formatter.string(from: date as Date)
  }
  

  /// 手机号正则
  ///
  /// - Returns: true or false
  func isTimeStamp(str:String)->Bool{

    // - 1、创建规则
    let pattern1 = "1[0-9]{12}"
    // - 2、创建正则表达式对象
    let regex1 = try! NSRegularExpression(pattern: pattern1, options: NSRegularExpression.Options.caseInsensitive)
    // - 3、开始匹配
    let res = regex1.matches(in: str, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, str.count)).count
    return res==1

  }
  
  private func checkAccessibilityPermissions() {
    let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue(): true]
    AXIsProcessTrustedWithOptions(options)
  }

  private func shouldIgnore(_ types: [NSPasteboard.PasteboardType]) -> Bool {
    return !Set(types.map({ $0.rawValue })).isDisjoint(with: ignoredTypes)
  }
}
