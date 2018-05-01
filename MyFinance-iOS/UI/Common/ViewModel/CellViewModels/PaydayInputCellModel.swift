protocol PaydayInputCellModelViewModelDelegate: InputCellModelViewModelDelegate {

    func defaultValue(paydayCell: PaydayInputCellModelForViewModelType) -> Payday
    func didChange(paydayCell: PaydayInputCellModelForViewModelType, value: Payday)

}

protocol PaydayInputCellModelForViewModelType: InputCellModelForViewModelType {

    var currentPaydayValue: Payday { get }

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

}

extension PaydayInputCellModel: PickerInputCellModelViewModelDelegate {

    func defaultValue(pickerCell: PickerInputCellModelForViewModelType) -> Describable {
        return paydayViewModelDelegate?.defaultValue(paydayCell: self) ?? Paydays.values[0]
    }

    func didChange(pickerCell: PickerInputCellModelForViewModelType, value: Describable) {
        paydayViewModelDelegate?.didChange(paydayCell: self, value: value as! Payday)
    }

    func isEnabled(inputCell: InputCellModelForViewModelType) -> Bool {
        return paydayViewModelDelegate?.isEnabled(inputCell: self) ?? true
    }

    func returnKeyType(inputCell: InputCellModelForViewModelType) -> UIReturnKeyType {
        return paydayViewModelDelegate?.returnKeyType(inputCell: self) ?? .done
    }

}
