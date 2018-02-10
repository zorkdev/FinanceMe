use_frameworks!
inhibit_all_warnings!

def pods
    pod 'SwiftLint'
    pod 'PromiseKit'
end

target 'MyFinance-iOS' do
    platform :ios, '11.2'
    pods
    pod 'SwiftMessages'
    pod 'Charts'
    pod 'NVActivityIndicatorView'
end

target 'MyFinanceExtension-iOS' do
    platform :ios, '11.2'
    pods
end

target 'MyFinance-macOS' do
    platform :osx, '10.13'
    pods
end

target 'MyFinanceExtension-macOS' do
    platform :osx, '10.13'
    pods
end

target 'MyFinanceKit-iOS' do
    platform :ios, '11.2'
    pods
    pod 'SwiftKeychainWrapper', :git => 'https://github.com/zorkdev/SwiftKeychainWrapper.git', :branch => 'develop'
end

target 'MyFinanceKit-macOS' do
    platform :osx, '10.13'
    pods
    pod 'SwiftKeychainWrapper', :git => 'https://github.com/zorkdev/SwiftKeychainWrapper.git', :branch => 'develop'
end

target 'MyFinanceKit-iOS-Tests' do
    platform :ios, '11.2'
    pods
end

target 'MyFinanceKit-macOS-Tests' do
    platform :osx, '10.13'
    pods
end
