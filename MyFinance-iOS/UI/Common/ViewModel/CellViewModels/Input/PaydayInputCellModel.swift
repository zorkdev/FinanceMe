protocol PaydayInputCellModelViewModelDelegate: InputCellModelViewModelDelegate {

    func defaultValue(paydayCell: PaydayInputCellModelForViewModelType) -> Payday

}

protocol PaydayInputCellModelForViewModelType: InputCellModelForViewModelType {

    var paydayViewModelDelegate: PaydayInputCellModelViewModelDelegate? { get set }
    var currentPaydayValue: Payday { get }

    func update(payday: Payday)

}

class PaydayInputCellModel: PickerInputCellModel {

    weak var paydayViewModelDelegate: PaydayInputCellModelViewModelDelegate?

    init() {
        super.init(label: "Payday", rows: Paydays.values)
        self.viewModelDelegate = self
    }

}

extension PaydayInputCellModel: PaydayInputCellModelForViewModelType {

    var currentPaydayValue: Payday {
        return currentValue as! Payday
    }

    func update(payday: Payday) {
        update(value: payday)
    }

}

extension PaydayInputCellModel: PickerInputCellModelViewModelDelegate {

    func defaultValue(pickerCell: PickerInputCellModelForViewModelType) -> Describable {
        return paydayViewModelDelegate?.defaultValue(paydayCell: self) ?? Paydays.values[0]
    }

    func didChangeValue() {
        paydayViewModelDelegate?.didChangeValue()
    }

    func isEnabled(inputCell: InputCellModelForViewModelType) -> Bool {
        return paydayViewModelDelegate?.isEnabled(inputCell: self) ?? true
    }

    func returnKeyType(inputCell: InputCellModelForViewModelType) -> UIReturnKeyType {
        return paydayViewModelDelegate?.returnKeyType(inputCell: self) ?? .done
    }

}
