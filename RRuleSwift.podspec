#
#  Created by teambition-ios on 2020/7/27.
#  Copyright © 2020 teambition. All rights reserved.
#     

Pod::Spec.new do |s|
  s.name             = 'RRuleSwift'
  s.version          = '0.5.1'
  s.summary          = 'Swift rrule library for working with recurrence rules of calendar dates.'
  s.description      = <<-DESC
  Swift rrule library for working with recurrence rules of calendar dates.
                       DESC

  s.homepage         = 'https://github.com/teambition/RRuleSwift'
  s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author           = { 'teambition mobile' => 'teambition-mobile@alibaba-inc.com' }
  s.source           = { :git => 'https://github.com/teambition/RRuleSwift.git', :tag => s.version.to_s }

  s.swift_version = '5.0'
  s.ios.deployment_target = '8.0'
  s.watchos.deployment_target = '2.0'

  s.frameworks   = "Foundation", "EventKit"  
  s.ios.frameworks   = "Foundation", "EventKit", "JavaScriptCore"
  s.source_files = 'Sources/*.swift', 'Sources/lib/*.js'
  s.watchos.exclude_files = 'Sources/Iterators.swift', 'JavaScriptBridge.swift'

end
