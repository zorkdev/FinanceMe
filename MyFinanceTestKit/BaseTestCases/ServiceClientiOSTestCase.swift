class ServiceClientiOSTestCase: XCTestCase {
    var mockAppState: MockAppStateiOS!

    override func setUp() {
        super.setUp()

        mockAppState = MockAppStateiOS()
    }
}
