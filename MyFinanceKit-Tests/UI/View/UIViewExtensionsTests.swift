@testable import MyFinanceKit

class UIViewExtensionsTests: XCTestCase {

    func testLayerCornerRadius() {
        let view = UIView()

        view.layerCornerRadius = 1
        XCTAssertEqual(view.layer.cornerRadius, 1)

        view.layer.cornerRadius = 2
        XCTAssertEqual(view.layerCornerRadius, 2)
    }

    func testShadowRadius() {
        let view = UIView()

        view.shadowRadius = 1
        XCTAssertEqual(view.layer.shadowRadius, 1)

        view.layer.shadowRadius = 2
        XCTAssertEqual(view.shadowRadius, 2)
    }

    func testShadowOpacity() {
        let view = UIView()

        view.shadowOpacity = 1
        XCTAssertEqual(view.layer.shadowOpacity, 1)

        view.layer.shadowOpacity = 2
        XCTAssertEqual(view.shadowOpacity, 2)
    }

    func testShadowColor() {
        let view = UIView()

        view.layer.shadowColor = nil
        XCTAssertNil(view.shadowColor)

        view.shadowColor = .red
        XCTAssertEqual(view.layer.shadowColor, UIColor.red.cgColor)

        view.layer.shadowColor = UIColor.blue.cgColor
        XCTAssertEqual(view.shadowColor, .blue)
    }

}
