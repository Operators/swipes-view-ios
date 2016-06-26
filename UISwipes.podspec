Pod::Spec.new do |spec|

spec.name             = "UISwipes"
spec.version          = "0.1.1"
spec.summary          = "UISwipesView (a Tinder-like View) displays views (or cards) to be swiped"

spec.description      = "UISwipesView (a Tinder-like View) displays views (or cards) to be swiped in all directions of your choice and also allows you to programatically swipe (with a button or a command)."

spec.homepage         = "https://github.com/Operators/swipes-view-ios"
spec.license          = "MIT"
spec.authors           = { "Christopher Miller" => "christopher.d.miller.1@gmail.com" }
spec.source           = { :git => "https://github.com/Operators/swipes-view-ios.git", :tag => spec.version.to_s }

spec.ios.deployment_target = "8.0"
spec.source_files     = 'UISwipes/**/*.{h,m}'
spec.frameworks = 'UIKit'

end