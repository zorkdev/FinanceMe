import XCTest
@testable import FinanceMeKit

final class StringRepresentableTests: XCTestCase {
    class TestModel: StringRepresentable {}
    final class TestModelSubclass: TestModel {}

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
