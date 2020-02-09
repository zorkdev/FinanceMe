import XCTest
import SwiftUI
import FinanceMeTestKit
@testable import FinanceMeKit

final class ErrorBannerViewTests: XCTestCase {
    struct TestView: View {
        let errorViewModel: ErrorViewModel

        var body: some View {
            Spacer().errorBanner(errorViewModel)
        }
    }

    func testView() {
        let errorViewModel = ErrorViewModel()
        let view = TestView(errorViewModel: errorViewModel)
        assert(view: view)
    }
}
