# -*- coding: utf-8 -*-
require 'cinch'
require 'cinch/plugins/identify'
require_relative 'globals'

$admin = "tomgavin"

class GnudismBot
  include Cinch::Plugin
  match /hello$/, method: :greet
    def greet(m)
    m.reply "welcome to #GNUdism!"
    end
end

bot = Cinch::Bot.new do
  configure do |c|
    # add all required options here
    c.plugins.plugins = [Cinch::Plugins::Identify, GnudismBot]
    c.plugins.options[Cinch::Plugins::Identify] = {
      :username => USERNAME,
      :password => PASSWORD,
      :type     => :nickserv,
    }
    c.nick = USERNAME
    c.server = "irc.freenode.org"
    c.channels = ["#gnudism"]
  end

  irc do
    def is_admin?(user)
      true if user.nick == $admin
    end
  end

  on :message, /^!op (.+)/ do |m, channel|
    m.channel.op(m.user) if m.user.is_admin?
  end

  on :message, /^!join (.+)/ do |m, channel|
    bot.join(channel) if is_admin?(m.user)
  end

  on :message, /^!part(?: (.+))?/ do |m, channel|
    # Part current channel if none is given
    channel = channel || m.channel

    if channel
      bot.part(channel) if is_admin?(m.user)
    end
  end

end

bot.start
