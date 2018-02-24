let isTesting = NSClassFromString("XCTestCase") != nil
let appDelegateName = isTesting ? nil : NSStringFromClass(AppDelegate.self)

UIApplicationMain(CommandLine.argc,
                  UnsafeMutableRawPointer(CommandLine.unsafeArgv)
                    .bindMemory(to: UnsafeMutablePointer<Int8>.self,
                                capacity: Int(CommandLine.argc)),
                  nil,
                  appDelegateName)
