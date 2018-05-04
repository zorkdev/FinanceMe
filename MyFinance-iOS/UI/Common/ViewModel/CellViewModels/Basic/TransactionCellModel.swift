protocol TransactionCellModelForViewModelType: BasicCellModelForViewModelType {

    func update(transaction: TransactionPresentable)

}

class TransactionCellModel {

    weak var viewDelegate: BasicCellModelViewDelegate?

    private var transaction: TransactionPresentable

    var title: String { return transaction.narrative }
    var detail: String { return transaction.amount }
    var detailColor: Color { return transaction.amountColor }

    init(transaction: TransactionPresentable) {
        self.transaction = transaction
    }

}

extension TransactionCellModel: BasicCellModelForViewType {}

extension TransactionCellModel: TransactionCellModelForViewModelType {

    var canEdit: Bool { return transaction.canEdit }

    func update(transaction: TransactionPresentable) {
        self.transaction = transaction
        viewDelegate?.update()
    }

}
