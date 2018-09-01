use_frameworks!
inhibit_all_warnings!

abstract_target 'MyFinance' do
    pod 'SwiftLint'
    pod 'PromiseKit/CorePromise'
    pod 'PromiseKit/Foundation'

    abstract_target 'iOS' do
        platform :ios, '11.3'
        target 'MyFinance-iOS' do
            pod 'SwiftMessages'
            pod 'Charts'
            pod 'NVActivityIndicatorView'
        end

        target 'MyFinanceExtension-iOS'
        target 'MyFinanceKit-iOS'
        target 'MyFinance-Tests-iOS'
        target 'MyFinanceKit-iOS-Tests'
        target 'MyFinanceKit-IntegrationTests'
    end

    abstract_target 'watchOS' do
        platform :watchos, '4.3'
        target 'MyFinance-watchOS'
        target 'MyFinanceExtension-watchOS'
        target 'MyFinanceKit-watchOS'
    end

    abstract_target 'tvOS' do
        platform :tvos, '11.3'
        target 'MyFinance-tvOS'
        target 'MyFinanceKit-tvOS'
        target 'MyFinanceKit-tvOS-Tests'
        target 'MyFinance-Tests-tvOS'
    end

    abstract_target 'macOS' do
        platform :osx, '10.13'
        target 'MyFinance-macOS'
        target 'MyFinanceExtension-macOS'
        target 'MyFinanceKit-macOS'
        target 'MyFinanceKit-macOS-Tests'
        target 'MyFinanceKit-macOS-Unsigned-Tests'
        target 'MyFinance-Tests-macOS'
    end
end
