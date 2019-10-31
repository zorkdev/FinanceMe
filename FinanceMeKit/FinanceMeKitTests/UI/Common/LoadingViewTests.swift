import XCTest
import SwiftUI
@testable import FinanceMeKit

class LoadingViewTests: XCTestCase {
    struct TestView: View {
        @State var isLoading = true

        var body: some View {
            Spacer().loading(isLoading: $isLoading)
        }
    }

    func testView() {
        assert(view: TestView())
    }
}
