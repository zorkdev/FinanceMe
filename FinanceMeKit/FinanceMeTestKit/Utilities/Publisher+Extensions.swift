import XCTest
import Combine

open class AsyncTestCase: XCTestCase {
    var cancellables: Set<AnyCancellable> = []
}

public extension Publisher {
    func assertSuccess(_ testCase: AsyncTestCase, once: Bool = true, assertion: @escaping (Output) -> Void) {
        testCase.waitUntil { done in
            var cancellable: AnyCancellable?

            let action = {
                cancellable?.cancel()
            }

            cancellable = self.receive(on: DispatchQueue.main)
                .mapError { error -> Failure in
                    XCTFail("Should not have failed.")
                    return error
                }
                .sink(receiveCompletion: { _ in }, receiveValue: { output in
                    assertion(output)
                    if once { action() }
                    done()
                })

            cancellable?.store(in: &testCase.cancellables)
        }
    }

    func assertFailure(_ testCase: AsyncTestCase, assertion: @escaping (Failure) -> Void) {
        testCase.waitUntil { done in
            self
                .mapError { error -> Failure in
                    assertion(error)
                    done()
                    return error
                }.receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    if case .finished = completion { XCTFail("Should have failed.") }
                }, receiveValue: { _ in })
                .store(in: &testCase.cancellables)
        }
    }
}
