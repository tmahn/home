# encoding: UTF-8

begin
  require 'wirble'

  Wirble.init
rescue LoadError => err
  warn "Couldn’t load Wirble: #{err}"
end

IRB.conf[:PROMPT_MODE] = :SIMPLE
IRB.conf[:SAVE_HISTORY] = 1000
