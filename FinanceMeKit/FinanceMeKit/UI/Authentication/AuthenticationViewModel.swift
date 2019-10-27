public class AuthenticationViewModel: ObservableObject {
    private let businessLogic: AuthenticationBusinessLogicType

    public init(businessLogic: AuthenticationBusinessLogicType) {
        self.businessLogic = businessLogic
    }

    func onAppear() {
        businessLogic.authenticate()
    }
}
