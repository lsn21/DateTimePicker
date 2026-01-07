Pod::Spec.new do |s|
  s.name             = 'DateTimePicker'
  s.version          = '1.0.0' # Обновите версию
  s.summary          = 'Date and Time Picker components.'
  
  s.description      = <<-DESC
DateTimePicker provides:
- @IBDesignable DateTimePicker with state-specific properties
                       DESC

  s.homepage         = 'https://github.com/lsn21/DateTimePicker'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Sergey Lukyanov' => 'lsn21@ya.ru' }
  s.source           = { :git => 'https://github.com/lsn21/DateTimePicker.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '15.0'
  s.swift_version = '5.0'
  s.source_files = 'Sources/**/*.swift'
  
  s.frameworks = 'UIKit'
end