Pod::Spec.new do |s|
  s.name             = 'DateTimePicker'
  s.version          = '1.2.1' # Обновите версию
  s.summary          = 'A collection of customizable Date and Time Picker components.'
  
  s.description      = <<-DESC
StatefulUIComponents provides:
- @IBDesignable StatefulUIButton with state-specific properties
- PlaceholderTextView with customizable placeholder
- Powerful IBInspectable extensions for all UIView subclasses
                       DESC

  s.homepage         = 'https://github.com/lsn21/StatefulUIComponents'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Sergey Lukyanov' => 'lsn21@ya.ru' }
  s.source           = { :git => 'https://github.com/lsn21/StatefulUIComponents.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '15.0'
  s.swift_version = '5.0'
  s.source_files = 'Sources/**/*.swift'
  
  s.frameworks = 'UIKit'
end
