public struct Diff {

    public var deletions: IndexSet
    public var insertions: IndexSet
    public var unchanged: IndexSet

}

public extension Array where Element: Hashable {

    func diff(other: Array) -> Diff {
        let newSet = Set(self)
        let oldSet = Set(other)

        let deletions = oldSet.subtracting(newSet)
        let insertions = newSet.subtracting(oldSet)
        let unchanged = newSet.intersection(oldSet)

        let deletionIndices = IndexSet(deletions.compactMap({ other.index(of: $0) }))
        let insertionIndices = IndexSet(insertions.compactMap({ self.index(of: $0) }))
        let unchangedIndices = IndexSet(unchanged.compactMap({ self.index(of: $0) }))

        return Diff(deletions: deletionIndices,
                    insertions: insertionIndices,
                    unchanged: unchangedIndices)
    }

}
