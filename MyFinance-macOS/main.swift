let isTesting = NSClassFromString("XCTestCase") != nil

if isTesting == false {
    NSApplication.shared.delegate = AppDelegate()
    let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
    let initialController = storyboard.instantiateInitialController() as? NSWindowController
    initialController?.window?.makeKeyAndOrderFront(nil)
}

NSApplication.shared.setActivationPolicy(.regular)
NSApplication.shared.activate(ignoringOtherApps: true)
NSApplication.shared.run()
