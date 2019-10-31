import XCTest
import SwiftUI
@testable import FinanceMeKit

class DismissTests: XCTestCase {
    struct DismissingTestView: View {
        @State var shouldDismiss = true
        @Environment(\.presentationMode) private var presentationMode

        var body: some View {
            Spacer().dismiss(shouldDismiss: $shouldDismiss)
        }
    }

    struct TestView: View {
        @State var shouldDismiss = false
        @Environment(\.presentationMode) private var presentationMode

        var body: some View {
            Spacer().dismiss(shouldDismiss: $shouldDismiss)
        }
    }

    func testView() {
        assert(view: DismissingTestView())
        assert(view: TestView())
    }
}
