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
        assert(view: TestView(errorViewModel: errorViewModel))
        errorViewModel.error = TestError()
        assert(view: TestView(errorViewModel: errorViewModel))
    }
}
