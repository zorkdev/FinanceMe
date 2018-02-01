import Foundation

extension Date {

    static let daysInWeek = 7

    private var calendar: Calendar {
        return Calendar.autoupdatingCurrent
    }

    var isThisWeek: Bool {
        return calendar.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }

    var startOfDay: Date {
        return calendar.startOfDay(for: self)
    }

    var startOfWeek: Date {
        let dateComponents = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear],
                                                     from: self)
        return calendar.date(from: dateComponents) ?? self
    }

    var endOfWeek: Date {
        return calendar.date(byAdding: .weekOfYear,
                             value: 1,
                             to: startOfWeek) ?? self
    }

    var oneMonthAgo: Date {
        return calendar.date(byAdding: .month,
                             value: -1,
                             to: self) ?? self
    }

    var daysInMonth: Int {
        return calendar.range(of: .day, in: .month, for: self)?.count ?? 0
    }

    var weeksInMonth: Double {
        return Double(daysInMonth) / Double(Date.daysInWeek)
    }

    var dayBefore: Date {
        return calendar.date(byAdding: .day, value: -1, to: self) ?? self
    }

    func next(day: Int, direction: Calendar.SearchDirection) -> Date {
        var dateComponents = DateComponents()
        dateComponents.day = day
        return calendar.nextDate(after: self,
                                 matching: dateComponents,
                                 matchingPolicy: Calendar.MatchingPolicy.strict,
                                 repeatedTimePolicy: Calendar.RepeatedTimePolicy.first,
                                 direction: direction) ?? self
    }

    func numberOfDays(from: Date) -> Int {
        return calendar.dateComponents([.day], from: from.startOfDay, to: self.startOfDay).day ?? 0
    }

}
