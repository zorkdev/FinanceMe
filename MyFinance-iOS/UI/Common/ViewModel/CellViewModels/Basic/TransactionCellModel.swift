protocol TransactionCellModelForViewModelType: BasicCellModelForViewModelType {

    func update(transaction: TransactionPresentable)

}

class TransactionCellModel {

    weak var viewDelegate: BasicCellModelViewDelegate?

    private var transaction: TransactionPresentable

    init(transaction: TransactionPresentable) {
        self.transaction = transaction
    }

}

extension TransactionCellModel: BasicCellModelForViewType {

    var title: String { return transaction.narrative }
    var detail: String { return transaction.amount }
    var detailColor: Color { return transaction.amountColor }

}

extension TransactionCellModel: TransactionCellModelForViewModelType {

    var id: Int { return transaction.id }
    var canEdit: Bool { return transaction.canEdit }

    func update(transaction: TransactionPresentable) {
        self.transaction = transaction
        viewDelegate?.update()
    }

}
