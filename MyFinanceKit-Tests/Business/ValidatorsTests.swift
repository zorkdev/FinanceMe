@testable import MyFinanceKit

class ValidatorsTests: XCTestCase {

    func testValidateAmount_Success() {
        XCTAssertTrue(Validators.validate(amount: "£0"))
        XCTAssertTrue(Validators.validate(amount: "£0."))
        XCTAssertTrue(Validators.validate(amount: "£0.0"))
        XCTAssertTrue(Validators.validate(amount: "£0.00"))
        XCTAssertTrue(Validators.validate(amount: "0"))
        XCTAssertTrue(Validators.validate(amount: "0."))
        XCTAssertTrue(Validators.validate(amount: "0.0"))
        XCTAssertTrue(Validators.validate(amount: "0.00"))
        XCTAssertTrue(Validators.validate(amount: "1.23"))
        XCTAssertTrue(Validators.validate(amount: "9999999.99"))
        XCTAssertTrue(Validators.validate(amount: "£1.23"))
        XCTAssertTrue(Validators.validate(amount: "£9999999.99"))
    }

    func testValidateAmount_Failure() {
        XCTAssertFalse(Validators.validate(amount: ""))
        XCTAssertFalse(Validators.validate(amount: "£"))
        XCTAssertFalse(Validators.validate(amount: "£01"))
        XCTAssertFalse(Validators.validate(amount: "£0.."))
        XCTAssertFalse(Validators.validate(amount: "£0.000"))
        XCTAssertFalse(Validators.validate(amount: "01"))
        XCTAssertFalse(Validators.validate(amount: "0.."))
        XCTAssertFalse(Validators.validate(amount: "0.000"))
        XCTAssertFalse(Validators.validate(amount: "a"))
        XCTAssertFalse(Validators.validate(amount: "%"))
        XCTAssertFalse(Validators.validate(amount: " "))
        XCTAssertFalse(Validators.validate(amount: "10000000.00"))
    }

    func testValidateFullAmount_Success() {
        XCTAssertTrue(Validators.validate(fullAmount: "1.23"))
        XCTAssertTrue(Validators.validate(fullAmount: "9999999.99"))
        XCTAssertTrue(Validators.validate(fullAmount: "£1.23"))
        XCTAssertTrue(Validators.validate(fullAmount: "£9999999.99"))
    }

    func testValidateFullAmount_Failure() {
        XCTAssertFalse(Validators.validate(fullAmount: "£0"))
        XCTAssertFalse(Validators.validate(fullAmount: "£0."))
        XCTAssertFalse(Validators.validate(fullAmount: "£0.0"))
        XCTAssertFalse(Validators.validate(fullAmount: "£0.00"))
        XCTAssertFalse(Validators.validate(fullAmount: "0"))
        XCTAssertFalse(Validators.validate(fullAmount: "0."))
        XCTAssertFalse(Validators.validate(fullAmount: "0.0"))
        XCTAssertFalse(Validators.validate(fullAmount: "0.00"))
        XCTAssertFalse(Validators.validate(fullAmount: ""))
        XCTAssertFalse(Validators.validate(fullAmount: "£"))
        XCTAssertFalse(Validators.validate(fullAmount: "£01"))
        XCTAssertFalse(Validators.validate(fullAmount: "£0.."))
        XCTAssertFalse(Validators.validate(fullAmount: "£0.000"))
        XCTAssertFalse(Validators.validate(fullAmount: "01"))
        XCTAssertFalse(Validators.validate(fullAmount: "0.."))
        XCTAssertFalse(Validators.validate(fullAmount: "0.000"))
        XCTAssertFalse(Validators.validate(fullAmount: "a"))
        XCTAssertFalse(Validators.validate(fullAmount: "%"))
        XCTAssertFalse(Validators.validate(fullAmount: " "))
        XCTAssertFalse(Validators.validate(fullAmount: "10000000.00"))
    }

    func testValidateFullEmail_Success() {
        XCTAssertTrue(Validators.validate(fullEmail: "test@test.com"))
        XCTAssertTrue(Validators.validate(fullEmail: "a@a.aa"))
        XCTAssertTrue(Validators.validate(fullEmail: "someone@something.co.uk"))
    }

    func testValidateFullEmail_Failure() {
        XCTAssertFalse(Validators.validate(fullEmail: "test@test.c"))
        XCTAssertFalse(Validators.validate(fullEmail: "a@a.a"))
        XCTAssertFalse(Validators.validate(fullEmail: "test@test."))
        XCTAssertFalse(Validators.validate(fullEmail: "test@."))
        XCTAssertFalse(Validators.validate(fullEmail: "@test.com"))
        XCTAssertFalse(Validators.validate(fullEmail: ".@."))
        XCTAssertFalse(Validators.validate(fullEmail: "test@com"))
        XCTAssertFalse(Validators.validate(fullEmail: "test@"))
        XCTAssertFalse(Validators.validate(fullEmail: "@"))
        XCTAssertFalse(Validators.validate(fullEmail: "."))
    }

}
