# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
require 'gmail_xoauth/version'

Gem::Specification.new do |s|
  s.name        = "gmail_xoauth"
  s.version     = GmailXoauth::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Nicolas Fouché"]
  s.email       = ["nicolas@silentale.com"]
  s.homepage    = "http://geeks.silentale.com/2010/05/26/gmail-and-oauth-ruby-gem"
  s.summary     = %Q{Get access to Gmail IMAP and STMP via OAuth, using the standard Ruby Net libraries}
  s.description = %Q{Get access to Gmail IMAP and STMP via OAuth, using the standard Ruby Net libraries}
 
  s.required_rubygems_version = ">= 1.3.6"
  # s.rubyforge_project         = "gmail_xoauth"
 
  s.add_dependency "oauth", ">= 0.3.6"
  s.add_development_dependency "shoulda", ">= 0"
 
  s.files        = Dir.glob("{bin,lib,test}/**/*") + %w(LICENSE README.markdown)
  s.files.reject! { |fn| fn.include? "valid_credentials.yml" }
  
  s.require_path = 'lib'
  
  s.rdoc_options = ["--charset=UTF-8"]
end
