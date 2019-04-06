Pod::Spec.new do |s|
  s.name             = 'RRuleSwift'
  s.version          = '0.1.1'
  s.summary          = 'Swift rrule library for working with recurrence rules of calendar dates.'
  s.homepage         = 'https://github.com/teambition/RRuleSwift'
  s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author           = { 'Teambition' => 'dev@teambition.com' }
  s.source           = { :git => 'https://github.com/teambition/RRuleSwift.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'Sources/**/*'
end
