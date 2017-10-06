Pod::Spec.new do |s|
  s.name         = "RRuleSwift"
  s.version      = "0.2.0"
  s.summary      = "Swift rrule library for working with recurrence rules of calendar dates."
  s.description  = <<-DESC
                   Swift rrule library for working with recurrence rules of calendar dates.
                   It wraps the rrule.js library (https://github.com/jkbrzt/rrule).
                   DESC

  s.homepage     = "https://github.com/teambition/RRuleSwift"
  s.screenshots  = "https://raw.githubusercontent.com/teambition/RRuleSwift/master/Gif/RRuleSwiftExample.gif"
  s.license      = "MIT"
  s.author       = { 'Teambition' => 'dev@teambition.com' }
  s.ios.deployment_target = "8.0"
  s.watchos.deployment_target = "2.0"
  s.source       = { :git => "https://github.com/teambition/RRuleSwift.git", :tag => "#{s.version}" }
  s.source_files = "Sources", "Sources/**/*.{h,m}"
  s.watchos.exclude_files = "Sources/JavaScriptBridge.swift", "Sources/Iterators.swift"
  s.resource     = "Sources/lib/*.js"
  s.frameworks   = "Foundation", "EventKit"
  s.ios.frameworks = "Foundation", "EventKit", "JavaScriptCore"
end
