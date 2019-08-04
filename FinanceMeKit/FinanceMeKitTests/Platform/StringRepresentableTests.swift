import XCTest
@testable import FinanceMeKit

class StringRepresentableTests: XCTestCase {
    class TestModel: StringRepresentable {}
    class TestModelSubclass: TestModel {}

    func testStaticStringRepresentable() {
        XCTAssertEqual(TestModel.instanceName, "TestModel")
    }

    func testSubclassStaticStringRepresentable() {
        XCTAssertEqual(TestModelSubclass.instanceName, "TestModelSubclass")
    }

    func testArrayStringRepresentable() {
        XCTAssertEqual([TestModel].instanceName, "Array<TestModel>")
    }
}
