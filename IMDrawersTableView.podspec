Pod::Spec.new do |s|
  s.name         = "IMDrawersTableView"
  s.version      = "1.0.0"
  s.summary      = "iOS custom table view with drawers."
  s.homepage     = "https://github.com/imilakovic/IMDrawersTableView"
  s.license      = {
    :type => 'MIT',
    :file => 'LICENSE'
  }
  s.author       = {
    "Igor Milakovic" => "igor.milakovic@gmail.com"
  }
  s.platform     = :ios, '7.0'
  s.source       = {
    :git => "https://github.com/imilakovic/IMDrawersTableView.git",
    :tag => "v1.0.0"
  }
  s.source_files = 'IMDrawersTableView', 'IMDrawersTableView/**/*.{h,m}'
  s.requires_arc = true
end
