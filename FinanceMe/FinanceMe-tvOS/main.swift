import UIKit
import FinanceMeKit

var appDelegateName: String? = NSStringFromClass(AppDelegate.self)

#if DEBUG
if isUnitTesting { appDelegateName = nil }
#endif

UIApplicationMain(CommandLine.argc,
                  CommandLine.unsafeArgv,
                  nil,
                  appDelegateName)
