import XCTest
import SwiftUI
@testable import FinanceMeKit

final class AmountViewModelTests: XCTestCase {
    func testDefault() {
        assert(AmountViewModel(value: 1200.34),
               sign: "",
               currencySymbol: "£",
               integer: "1,200",
               decimalSeparator: ".",
               fraction: "34",
               string: "£1,200.34",
               integerString: "1,200",
               color: nil)

        assert(AmountViewModel(value: -1200.34),
               sign: "-",
               currencySymbol: "£",
               integer: "1,200",
               decimalSeparator: ".",
               fraction: "34",
               string: "-£1,200.34",
               integerString: "-1,200",
               color: .red)

        assert(AmountViewModel(value: -10000.67),
               sign: "-",
               currencySymbol: "£",
               integer: "10,000",
               decimalSeparator: ".",
               fraction: "67",
               string: "-£10,000.67",
               integerString: "-10,000",
               color: .red)
    }

    func testWithPlusMinusSign() {
        let signs: [AmountViewModel.Sign] = [.plus, .minus]

        assert(AmountViewModel(value: 12.34, signs: signs),
               sign: "+",
               currencySymbol: "£",
               integer: "12",
               decimalSeparator: ".",
               fraction: "34",
               string: "+£12.34",
               integerString: "+12",
               color: .green)

        assert(AmountViewModel(value: -12.34, signs: signs),
               sign: "-",
               currencySymbol: "£",
               integer: "12",
               decimalSeparator: ".",
               fraction: "34",
               string: "-£12.34",
               integerString: "-12",
               color: .red)

        assert(AmountViewModel(value: 0, signs: signs),
               sign: "",
               currencySymbol: "£",
               integer: "0",
               decimalSeparator: ".",
               fraction: "00",
               string: "£0.00",
               integerString: "0",
               color: nil)

        assert(AmountViewModel(value: -0, signs: signs),
               sign: "",
               currencySymbol: "£",
               integer: "0",
               decimalSeparator: ".",
               fraction: "00",
               string: "£0.00",
               integerString: "0",
               color: nil)
    }

    func testWithNoSign() {
        let signs: [AmountViewModel.Sign] = []

        assert(AmountViewModel(value: 12.34, signs: signs),
               sign: "",
               currencySymbol: "£",
               integer: "12",
               decimalSeparator: ".",
               fraction: "34",
               string: "£12.34",
               integerString: "12",
               color: nil)

        assert(AmountViewModel(value: -12.34, signs: signs),
               sign: "",
               currencySymbol: "£",
               integer: "12",
               decimalSeparator: ".",
               fraction: "34",
               string: "£12.34",
               integerString: "12",
               color: nil)
    }

    // swiftlint:disable:next function_parameter_count
    private func assert(_ viewModel: AmountViewModel,
                        sign: String,
                        currencySymbol: String,
                        integer: String,
                        decimalSeparator: String,
                        fraction: String,
                        string: String,
                        integerString: String,
                        color: Color?) {
        XCTAssertEqual(viewModel.sign, sign)
        XCTAssertEqual(viewModel.currencySymbol, currencySymbol)
        XCTAssertEqual(viewModel.integer, integer)
        XCTAssertEqual(viewModel.decimalSeparator, decimalSeparator)
        XCTAssertEqual(viewModel.fraction, fraction)
        XCTAssertEqual(viewModel.string, string)
        XCTAssertEqual(viewModel.integerString, integerString)
        XCTAssertEqual(viewModel.color, color)
    }
}
