require 'yaml'

require 'rubygems'
require 'test/unit'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'gmail_xoauth'

# Wanna debug ? Activate the IMAP debug mode, it will show the client/server conversation
# Net::IMAP.debug = true

VALID_CREDENTIALS = begin
  YAML.load_file(File.join(File.dirname(__FILE__), 'valid_credentials.yml'))
rescue Errno::ENOENT
  STDERR.puts %(
Warning: some tests are disabled because they require valid credentials. To enable them, create a file \"test/valid_credentials.yml\".
It should contain valid OAuth tokens. Valid tokens can be generated thanks to \"xoauth.py\":http://code.google.com/p/google-mail-xoauth-tools/.
Of course, this file is .gitignored. Template:

---
:email: someuser@gmail.com
:consumer_key: anonymous # "anonymous" is a valid value for testing
:consumer_secret: anonymous # "anonymous" is a valid value for testing
:token: 1/nE2xBCDOU0429bTeJySE11kRE95qzKQNlfTaaBcDeFg
:token_secret: 123Z/bMsi9fFhN6qHFWOabcd

)
  false
end

class Test::Unit::TestCase
end
