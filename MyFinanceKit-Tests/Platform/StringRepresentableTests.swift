@testable import MyFinanceKit

class StringRepresentableTests: XCTestCase {
    class TestModel: StringRepresentable {}
    class TestModelSubclass: TestModel {}

    func testStaticStringRepresentable() {
        XCTAssertEqual(TestModel.instanceName, "TestModel")
    }

    func testSubclassStaticStringRepresentable() {
        XCTAssertEqual(TestModelSubclass.instanceName, "TestModelSubclass")
    }

    func testInstanceStringRepresentable() {
        let testModel = TestModel()
        XCTAssertEqual(testModel.instanceName, "TestModel")
    }

    func testSubclassInstanceStringRepresentable() {
        let testModelSubclass = TestModelSubclass()
        XCTAssertEqual(testModelSubclass.instanceName, "TestModelSubclass")
    }

    func testArrayStringRepresentable() {
        let testModels = [TestModel]()
        XCTAssertEqual(testModels.instanceName, "Array<TestModel>")
    }

    func testDictionaryStringRepresentable() {
        let testModelDictionary = [String: TestModel]()
        XCTAssertEqual(testModelDictionary.instanceName, "Dictionary<String, TestModel>")
    }

    func testOptionalStringRepresentable() {
        let testModel: TestModel? = TestModel()
        XCTAssertEqual(testModel.instanceName, "Optional<TestModel>")
    }
}
