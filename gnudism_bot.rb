require 'cinch'
require 'cinch/plugins/identify'
require_relative 'credentials'

class GnudismBot
  def initialize
    bot = Cinch::Bot.new do
      configure do |c|
        # add all required options here
        c.plugins.plugins = [Cinch::Plugins::Identify] # optionally add more plugins
        c.plugins.options[Cinch::Plugins::Identify] = {
          :username => USERNAME,
          :password => PASSWORD,
          :type     => :nickserv,
        }
        c.nick = USERNAME
        c.server = "irc.freenode.org"
        c.channels = ["#gnudism"]
      end
    end
    bot.start
  end
end

gb = GnudismBot.new
gb
