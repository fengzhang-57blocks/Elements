Pod::Spec.new do |spec|
  spec.name = 'SwiftElements'
  spec.version = '0.0.19'
  spec.license = 'MIT'
  spec.summary = 'Elements kit for Swift.'
  spec.author = { 'mkjfeng01' => 'zfeng0712@gmail.com' }
  spec.homepage = 'https://github.com/fengzhang-57blocks/SwiftElements'

  spec.ios.deployment_target = '13.0'
  spec.source = { :git => 'https://github.com/fengzhang-57blocks/SwiftElements.git', :tag => '0.0.19' }

  spec.subspec 'PagingViewController' do |s|
    s.source_files = 'SwiftElements/Sources/PagingViewController/Classes/**.swift', 'SwiftElements/Sources/PagingViewController/Enums/**.swift', 'SwiftElements/Sources/PagingViewController/Extensions/**.swift', 'SwiftElements/Sources/PagingViewController/Structs/**.swift', 'SwiftElements/Sources/PagingViewController/Protocols/**.swift'
  end

  spec.subspec 'PhotonActionSheet' do |s|
    s.source_files = 'SwiftElements/Sources/PhotonActionSheet/Classes/**.swift', 'SwiftElements/Sources/PhotonActionSheet/Structs/**.swift', 'SwiftElements/Sources/PhotonActionSheet/Extensions/**.swift'
    s.resource = 'SwiftElements/Sources/PhotonActionSheet/Resources/*.bundle'
  end

  spec.swift_versions = ['5.0']
end
