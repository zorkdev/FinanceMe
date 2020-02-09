@testable import FinanceMeKit

public class MockMenuItem: MenuItem {
    public var target: AnyObject?
    public var action: Selector?
    public var isEnabled = false

    public init() {}
}
