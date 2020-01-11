import XCTest
@testable import FinanceMeKit

final class AmountViewModelTests: XCTestCase {
    func testDefault() {
        let viewModel1 = AmountViewModel(value: 1200.34)

        XCTAssertEqual(viewModel1.sign, "")
        XCTAssertEqual(viewModel1.currencySymbol, "£")
        XCTAssertEqual(viewModel1.integer, "1,200")
        XCTAssertEqual(viewModel1.decimalSeparator, ".")
        XCTAssertEqual(viewModel1.fraction, "34")
        XCTAssertEqual(viewModel1.string, "£1,200.34")
        XCTAssertEqual(viewModel1.integerString, "1,200")
        XCTAssertFalse(viewModel1.isNegative)

        let viewModel2 = AmountViewModel(value: -1200.34)

        XCTAssertEqual(viewModel2.sign, "-")
        XCTAssertEqual(viewModel2.currencySymbol, "£")
        XCTAssertEqual(viewModel2.integer, "1,200")
        XCTAssertEqual(viewModel2.decimalSeparator, ".")
        XCTAssertEqual(viewModel2.fraction, "34")
        XCTAssertEqual(viewModel2.string, "-£1,200.34")
        XCTAssertEqual(viewModel2.integerString, "-1,200")
        XCTAssertTrue(viewModel2.isNegative)
    }

    func testWithPlusMinusSign() {
        let viewModel1 = AmountViewModel(value: 12.34, signs: [.plus, .minus])

        XCTAssertEqual(viewModel1.sign, "+")
        XCTAssertEqual(viewModel1.currencySymbol, "£")
        XCTAssertEqual(viewModel1.integer, "12")
        XCTAssertEqual(viewModel1.decimalSeparator, ".")
        XCTAssertEqual(viewModel1.fraction, "34")
        XCTAssertEqual(viewModel1.string, "+£12.34")
        XCTAssertEqual(viewModel1.integerString, "+12")
        XCTAssertFalse(viewModel1.isNegative)

        let viewModel2 = AmountViewModel(value: -12.34, signs: [.plus, .minus])

        XCTAssertEqual(viewModel2.sign, "-")
        XCTAssertEqual(viewModel2.currencySymbol, "£")
        XCTAssertEqual(viewModel2.integer, "12")
        XCTAssertEqual(viewModel2.decimalSeparator, ".")
        XCTAssertEqual(viewModel2.fraction, "34")
        XCTAssertEqual(viewModel2.string, "-£12.34")
        XCTAssertEqual(viewModel2.integerString, "-12")
        XCTAssertTrue(viewModel2.isNegative)
    }

    func testWithNoSign() {
        let viewModel1 = AmountViewModel(value: 12.34, signs: [])

        XCTAssertEqual(viewModel1.sign, "")
        XCTAssertEqual(viewModel1.currencySymbol, "£")
        XCTAssertEqual(viewModel1.integer, "12")
        XCTAssertEqual(viewModel1.decimalSeparator, ".")
        XCTAssertEqual(viewModel1.fraction, "34")
        XCTAssertEqual(viewModel1.string, "£12.34")
        XCTAssertEqual(viewModel1.integerString, "12")
        XCTAssertFalse(viewModel1.isNegative)

        let viewModel2 = AmountViewModel(value: -12.34, signs: [])

        XCTAssertEqual(viewModel2.sign, "")
        XCTAssertEqual(viewModel2.currencySymbol, "£")
        XCTAssertEqual(viewModel2.integer, "12")
        XCTAssertEqual(viewModel2.decimalSeparator, ".")
        XCTAssertEqual(viewModel2.fraction, "34")
        XCTAssertEqual(viewModel2.string, "£12.34")
        XCTAssertEqual(viewModel1.integerString, "12")
        XCTAssertTrue(viewModel2.isNegative)
    }
}
