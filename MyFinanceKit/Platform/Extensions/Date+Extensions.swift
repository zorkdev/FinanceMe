public extension Date {

    static let daysInWeek = 7

    private var calendar: Calendar {
        return Calendar.autoupdatingCurrent
    }

    var isToday: Bool {
        return calendar.isDateInToday(self)
    }

    var isYesterday: Bool {
        return calendar.isDateInYesterday(self)
    }

    var isThisWeek: Bool {
        return calendar.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }

    var isThisYear: Bool {
        return calendar.isDate(self, equalTo: Date(), toGranularity: .year)
    }

    var startOfDay: Date {
        return calendar.startOfDay(for: self)
    }

    var startOfWeek: Date {
        let dateComponents = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear],
                                                     from: self)
        return calendar.date(from: dateComponents)!
    }

    var startOfYear: Date {
        let dateComponents = calendar.dateComponents([.year],
                                                     from: self)
        return calendar.date(from: dateComponents)!
    }

    var endOfWeek: Date {
        return calendar.date(byAdding: .weekOfYear,
                             value: 1,
                             to: startOfWeek)!
    }

    var oneMonthAgo: Date {
        return calendar.date(byAdding: .month,
                             value: -1,
                             to: self)!
    }

    var daysInMonth: Int {
        return calendar.range(of: .day, in: .month, for: self)!.count
    }

    var weeksInMonth: Double {
        return Double(daysInMonth) / Double(Date.daysInWeek)
    }

    var dayBefore: Date {
        return calendar.date(byAdding: .day, value: -1, to: self)!
    }

    func isInSameDay(as date: Date) -> Bool {
        return calendar.isDate(self, equalTo: date, toGranularity: .day)
    }

    func next(day: Int, direction: Calendar.SearchDirection) -> Date {
        var dateComponents = DateComponents()
        dateComponents.day = day
        return calendar.nextDate(after: self,
                                 matching: dateComponents,
                                 matchingPolicy: Calendar.MatchingPolicy.strict,
                                 repeatedTimePolicy: Calendar.RepeatedTimePolicy.first,
                                 direction: direction)!
    }

    func numberOfDays(from: Date) -> Int {
        return calendar.dateComponents([.day], from: from.startOfDay, to: self.startOfDay).day!
    }

}
