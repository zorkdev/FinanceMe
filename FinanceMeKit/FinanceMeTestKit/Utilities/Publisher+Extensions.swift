import XCTest
import Combine

public extension Publisher {
    func assertSuccess(_ testCase: XCTestCase, assertion: @escaping (Output) -> Void) {
        testCase.waitUntil { done in
            _ = self.receive(on: DispatchQueue.main)
                .mapError { error -> Failure in
                    XCTFail("Should not have failed.")
                    done()
                    return error
                }
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTFail(error.localizedDescription)
                        done()
                        return
                    }
                }, receiveValue: { output in
                    assertion(output)
                    done()
                })
        }
    }

    func assertFailure(_ testCase: XCTestCase, assertion: @escaping (Failure) -> Void) {
        testCase.waitUntil { done in
            _ = self
                .mapError { error -> Failure in
                    assertion(error)
                    done()
                    return error
                }.receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    if case .finished = completion {
                        XCTFail("Should have failed.")
                        done()
                        return
                    }
                }, receiveValue: { _ in })
        }
    }
}
