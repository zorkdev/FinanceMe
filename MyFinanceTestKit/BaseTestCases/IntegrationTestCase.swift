class IntegrationTestCase: XCTestCase {
    var config: Config!

    override func setUp() {
        super.setUp()

        config = Config()
    }

    override func tearDown() {
        super.tearDown()

        config.appState.dataService.removeAll()
    }
}
