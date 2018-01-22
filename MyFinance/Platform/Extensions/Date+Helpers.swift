extension Date {

    static let daysInWeek = 7

    private var calendar: Calendar {
        return Calendar.autoupdatingCurrent
    }

    var isThisWeek: Bool {
        return calendar.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }

    var startOfWeek: Date {
        let dateComponents = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear],
                                                     from: self)
        return calendar.date(from: dateComponents) ?? Date()
    }

    var endOfWeek: Date {
        return calendar.date(byAdding: .weekOfYear,
                             value: 1,
                             to: startOfWeek) ?? Date()
    }

    var oneMonthAgo: Date {
        return calendar.date(byAdding: .month,
                             value: -1,
                             to: self) ?? Date()
    }

    var daysInMonth: Int {
        return calendar.range(of: .day, in: .month, for: self)?.count ?? 0
    }

    var weeksInMonth: Double {
        return Double(daysInMonth) / Double(Date.daysInWeek)
    }

    func next(day: Int, direction: Calendar.SearchDirection) -> Date {
        var dateComponents = DateComponents()
        dateComponents.day = day
        return calendar.nextDate(after: self,
                                 matching: dateComponents,
                                 matchingPolicy: Calendar.MatchingPolicy.strict,
                                 repeatedTimePolicy: Calendar.RepeatedTimePolicy.first,
                                 direction: direction) ?? Date()
    }

    func numberOfDays(from: Date) -> Int {
        return calendar.dateComponents([.day], from: from, to: self).day ?? 0
    }

}
