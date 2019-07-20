@testable import MyFinance_iOS

class MockInputCellModel: InputCellModelForViewModelType {
    var isValid: Bool = false

    func becomeFirstResponder() {}
}

class MockAmountInputCellModel: AmountInputCellModelForViewModelType {
    //swiftlint:disable weak_delegate
    var viewModelDelegate: AmountInputCellModelViewModelDelegate?
    var currentValue: Double?
    var isValid: Bool = false

    func becomeFirstResponder() {}
    func update(value: Double?) {}
}

class MockDateInputCellModel: DateInputCellModelForViewModelType {
    //swiftlint:disable weak_delegate
    var viewModelDelegate: DateInputCellModelViewModelDelegate?
    var currentValue = Date()
    var isValid: Bool = false

    func becomeFirstResponder() {}
    func update(value: Date) {}
}

class MockTextInputCellModel: TextInputCellModelForViewModelType {
    //swiftlint:disable weak_delegate
    var viewModelDelegate: TextInputCellModelViewModelDelegate?
    var currentValue: String?
    var isValid: Bool = false

    func becomeFirstResponder() {}
    func update(value: String) {}
}

class MockPaydayInputCellModel: PaydayInputCellModelForViewModelType {
    //swiftlint:disable weak_delegate
    var paydayViewModelDelegate: PaydayInputCellModelViewModelDelegate?
    var currentPaydayValue = Payday(intValue: 1)
    var isValid: Bool = false

    func becomeFirstResponder() {}
    func update(payday: Payday) {}
}
