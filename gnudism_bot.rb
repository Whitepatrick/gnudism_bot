#/usr/bin/env ruby
# #gnudism on irc.freenode.net

require 'cinch'
require_relative 'vars'

# building off of:
# https://github.com/cinchrb/cinch (thanks dog)

# Give this bot ops in a channel and it'll auto voice
# visitors
#
# Enable with !autovoice on
# Disable with !autovoice off
#
# It starts out disabled.
bot = Cinch::Bot.new do
  configure do |c|
    c.nick = USERNAME
    c.server = "irc.freenode.org"
    c.verbose = true
    c.channels = ["#gnudism"]
  end

  # auto voice
  on :join do |m|
    unless m.user.nick == bot.nick # We shouldn't attempt to voice ourselves
      m.channel.voice(m.user) if @autovoice
    end
  end

  # turn on autovoice
  on :channel, /^!autovoice (on|off)$/ do |m, option|
    @autovoice = option == "on"
    m.reply "Autovoice is now #{@autovoice ? 'enabled' : 'disabled'}"
  end

  # auto op user
  on :join do |op|
    if op.user.nick == "" # We shouldn't attempt to voice ourselves
      op.channel.voice(op.user) if @autoop
    end
  end
  on :channel, /^!autoop (on|off)$/ do |m, option|
    @autoop = option == "on"
    m.reply "Owner op is now #{@autoop ? 'enabled' : 'disabled'}"
  end
end
bot.start