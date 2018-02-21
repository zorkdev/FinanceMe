@testable import MyFinanceKit

class ValidatorsTests: XCTestCase {

    func testValidateAmount_Success() {
        let c = Formatters.currencySymbol

        XCTAssertTrue(Validators.validate(amount: "\(c)0"))
        XCTAssertTrue(Validators.validate(amount: "\(c)0."))
        XCTAssertTrue(Validators.validate(amount: "\(c)0.0"))
        XCTAssertTrue(Validators.validate(amount: "\(c)0.00"))
        XCTAssertTrue(Validators.validate(amount: "0"))
        XCTAssertTrue(Validators.validate(amount: "0."))
        XCTAssertTrue(Validators.validate(amount: "0.0"))
        XCTAssertTrue(Validators.validate(amount: "0.00"))
        XCTAssertTrue(Validators.validate(amount: "1.23"))
        XCTAssertTrue(Validators.validate(amount: "9999999.99"))
    }

    func testValidateAmount_Failure() {
        let c = Formatters.currencySymbol

        XCTAssertFalse(Validators.validate(amount: ""))
        XCTAssertFalse(Validators.validate(amount: "\(c)"))
        XCTAssertFalse(Validators.validate(amount: "\(c)01"))
        XCTAssertFalse(Validators.validate(amount: "\(c)0.."))
        XCTAssertFalse(Validators.validate(amount: "\(c)0.000"))
        XCTAssertFalse(Validators.validate(amount: "01"))
        XCTAssertFalse(Validators.validate(amount: "0.."))
        XCTAssertFalse(Validators.validate(amount: "0.000"))
        XCTAssertFalse(Validators.validate(amount: "a"))
        XCTAssertFalse(Validators.validate(amount: "%"))
        XCTAssertFalse(Validators.validate(amount: " "))
        XCTAssertFalse(Validators.validate(amount: "10000000.00"))
    }

}