extension Date {

    private var calendar: Calendar {
        return Calendar.autoupdatingCurrent
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

    func numberOfDays(from: Date) -> Int {
        return calendar.dateComponents([.day], from: from, to: self).day ?? 0
    }

}
