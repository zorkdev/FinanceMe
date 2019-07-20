protocol CategoryInputCellModelViewModelDelegate: InputCellModelViewModelDelegate {
    func defaultValue(categoryCell: CategoryInputCellModelForViewModelType) -> TransactionSource
}

protocol CategoryInputCellModelForViewModelType: InputCellModelForViewModelType {
    var categoryViewModelDelegate: CategoryInputCellModelViewModelDelegate? { get set }
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
        return (currentValue as? TransactionSource)!
    }
}

extension CategoryInputCellModel: PickerInputCellModelViewModelDelegate {
    func defaultValue(pickerCell: PickerInputCellModelForViewModelType) -> Describable {
        return categoryViewModelDelegate?.defaultValue(categoryCell: self) ?? TransactionSource.externalValues[0]
    }

    func didChangeValue() {
        categoryViewModelDelegate?.didChangeValue()
    }

    func isEnabled(inputCell: InputCellModelForViewModelType) -> Bool {
        return categoryViewModelDelegate?.isEnabled(inputCell: self) ?? true
    }

    func returnKeyType(inputCell: InputCellModelForViewModelType) -> UIReturnKeyType {
        return categoryViewModelDelegate?.returnKeyType(inputCell: self) ?? .done
    }
}
