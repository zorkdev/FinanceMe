let isTesting = NSClassFromString("XCTestCase") != nil

let delegate = AppDelegate()
NSApplication.shared.delegate = delegate
let storyboard = NSStoryboard(name: NSViewController.storyboardId,
                              bundle: nil)
let initialController = storyboard.instantiateInitialController() as? NSWindowController

if isTesting == false { initialController?.window?.makeKeyAndOrderFront(nil) }

NSApplication.shared.setActivationPolicy(.regular)
NSApplication.shared.activate(ignoringOtherApps: true)
NSApplication.shared.run()
