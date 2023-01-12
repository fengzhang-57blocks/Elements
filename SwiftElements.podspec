Pod::Spec.new do |spec|
  spec.name = 'SwiftElements'
  spec.version = '0.0.8'
  spec.license = 'MIT'
  spec.summary = 'Elements kit for Swift.'
  spec.author = { 'mkjfeng01' => 'zfeng0712@gmail.com' }
  spec.homepage = 'https://github.com/fengzhang-57blocks/SwiftElements'

  spec.ios.deployment_target = '13.0'
  spec.source = { :git => 'https://github.com/fengzhang-57blocks/SwiftElements.git', :tag => '0.0.8' }

  spec.subspec 'SegmentControl' do |s|
    s.source_files = 'Source/SegmentControl/**.swift', 'Source/SegmentControl/Cell/**.swift', 'Source/SegmentControl/Extensions/**.swift'
  end

  spec.subspec 'PhotonActionSheet' do |s|
    s.source_files = 'Source/PhotonActionSheet/**.swift', 'Source/PhotonActionSheet/Extensions/**.swift'
    s.resource = 'Source/PhotonActionSheet/Resource/*.bundle'
  end

  spec.swift_versions = ['5.0']
end
