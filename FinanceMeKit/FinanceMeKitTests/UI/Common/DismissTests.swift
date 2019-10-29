import XCTest
import SwiftUI
@testable import FinanceMeKit

class DismissTests: XCTestCase {
    struct DismissingTestView: View {
        @State var shouldDismiss = true
        @Environment(\.presentationMode) private var presentationMode

        var body: some View {
            Dismiss($shouldDismiss, presentationMode: presentationMode)
        }
    }

    struct TestView: View {
        @State var shouldDismiss = false
        @Environment(\.presentationMode) private var presentationMode

        var body: some View {
            Dismiss($shouldDismiss, presentationMode: presentationMode)
        }
    }

    func testView() {
        assert(view: DismissingTestView())
        assert(view: TestView())
    }
}
