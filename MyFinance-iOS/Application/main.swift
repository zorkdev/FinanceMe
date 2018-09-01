let isTesting = NSClassFromString("XCTestCase") != nil
let appDelegateName = isTesting ? nil : NSStringFromClass(AppDelegate.self)

UIApplicationMain(CommandLine.argc,
                  CommandLine.unsafeArgv,
                  nil,
                  appDelegateName)
