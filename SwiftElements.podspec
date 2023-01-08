Pod::Spec.new do |spec|
  spec.name = "SwiftElements"
  spec.version = "0.0.1"
  spec.license = "MIT"
  spec.summary = "Elements kit for Swift."

  spec.homepage = "https://github.com/fengzhang-57blocks/SwiftElements"

  spec.author = { "mkjfeng01" => "zfeng0712@gmail.com" }

  spec.ios.deployment_target = "11.0"

  spec.source = { :git => "https://github.com/fengzhang-57blocks/SwiftElements.git", :tag => "0.0.1" }

  spec.source_files  = "Source/**/*.swift"

  spec.swift_versions = ['5.0']

end
