import Foundation

public extension String {
    var utf8Data: Data { .init(self.utf8) }
}
