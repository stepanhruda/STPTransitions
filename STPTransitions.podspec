Pod::Spec.new do |s|

  s.name         = "STPTransitions"
  s.version      = "0.0.1"
  s.summary      = "A short description of STPTransitions."

  s.description  = <<-DESC
                   A longer description of STPTransitions in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.homepage     = "http://github.com/stepanhruda/STPTransitions"

  s.license      = 'MIT'

  s.author       = { "Stepan Hruda" => "stepan.hruda@gmail.com" }

  s.platform     = :ios, '7.0'

  s.source       = { :git => "https://github.com/stepanhruda/STPTransitions.git", :tag => "0.0.1" }

  s.source_files  = 'Classes', 'Classes/**/*.{h,m}'

  s.requires_arc = true

  s.framework  = 'UIKit'

end
