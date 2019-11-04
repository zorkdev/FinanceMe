import XCTest

extension XCUIElement {
    func clearAndTypeText(_ text: String) {
        tap()

        if let value = value as? String, value.isEmpty == false {
            value.forEach { _ in typeText(XCUIKeyboardKey.delete.rawValue) }
        }

        text.forEach { typeText(String($0)) }
    }

    func waitForDisappearance(timeout: TimeInterval = 20) {
        let predicate = NSPredicate(format: "exists == false")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: self)
        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
        XCTAssertTrue(result == .completed, "\(description) never disappeared")
    }
}
