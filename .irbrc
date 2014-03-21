# encoding: UTF-8

begin
  require 'wirble'

  Wirble.init
rescue LoadError => err
  warn "Couldn’t load Wirble: #{err}"
end

IRB.conf[:PROMPT_MODE] = :SIMPLE
IRB.conf[:SAVE_HISTORY] = 1000

require 'rdoc/ri/driver'

# simulate `ri -a` when using IRB’s help() method
module IrbHacks
  @@orig_default_options = RDoc::RI::Driver.default_options

  def self.orig_default_options
    @@orig_default_options
  end
end

class RDoc::RI::Driver
  def self.default_options
    options = ::IrbHacks.orig_default_options
    options[:show_all] = true
    options
  end
end
