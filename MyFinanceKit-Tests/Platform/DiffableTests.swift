@testable import MyFinanceKit

class DiffableTests: XCTestCase {
    func testDiff() {
        let array1 = ["a", "b", "c", "d", "e"]
        let array2 = ["b", "c", "d", "e", "f", "g"]

        let diff = array1.diff(other: array2)

        XCTAssertEqual(diff.insertions, [0])
        XCTAssertEqual(diff.deletions, [4, 5])
        XCTAssertEqual(diff.unchanged, [1, 2, 3, 4])
    }
}
