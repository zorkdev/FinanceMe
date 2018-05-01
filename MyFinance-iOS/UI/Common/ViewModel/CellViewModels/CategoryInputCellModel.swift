protocol CategoryInputCellModelViewModelDelegate: InputCellModelViewModelDelegate {

    func defaultValue(categoryCell: CategoryInputCellModelForViewModelType) -> TransactionSource
    func didChange(categoryCell: CategoryInputCellModelForViewModelType, value: TransactionSource)

}

protocol CategoryInputCellModelForViewModelType: InputCellModelForViewModelType {

    var currentCategoryValue: TransactionSource { get }

}

class CategoryInputCellModel: PickerInputCellModel {

    weak var categoryViewModelDelegate: CategoryInputCellModelViewModelDelegate?

    init() {
        super.init(label: "Category", rows: TransactionSource.externalValues)
        self.viewModelDelegate = self
    }

}

extension CategoryInputCellModel: CategoryInputCellModelForViewModelType {

    var currentCategoryValue: TransactionSource {
        return currentValue as! TransactionSource
    }

}

extension CategoryInputCellModel: PickerInputCellModelViewModelDelegate {

    func defaultValue(pickerCell: PickerInputCellModelForViewModelType) -> Describable {
        return categoryViewModelDelegate?.defaultValue(categoryCell: self) ?? TransactionSource.externalValues[0]
    }

    func didChange(pickerCell: PickerInputCellModelForViewModelType, value: Describable) {
        categoryViewModelDelegate?.didChange(categoryCell: self, value: value as! TransactionSource)
    }

    func isEnabled(inputCell: InputCellModelForViewModelType) -> Bool {
        return categoryViewModelDelegate?.isEnabled(inputCell: self) ?? true
    }

    func returnKeyType(inputCell: InputCellModelForViewModelType) -> UIReturnKeyType {
        return categoryViewModelDelegate?.returnKeyType(inputCell: self) ?? .done
    }

}
