extension Decimal {
    var integer: Decimal { abs(floored) }
    var fraction: Decimal { (abs(self) - integer) * 100 }

    var floored: Decimal {
        let mode: NSDecimalNumber.RoundingMode = isSignMinus ? .up : .down
        return rounded(scale: 0, mode: mode)
    }

    func rounded(scale: Int, mode: NSDecimalNumber.RoundingMode) -> Decimal {
        var result = Decimal()
        var localCopy = self
        NSDecimalRound(&result, &localCopy, scale, mode)
        return result
    }
}
