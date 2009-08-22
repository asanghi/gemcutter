require 'command_helper'

class TumbleCommandTest < CommandTest
  context "with a tumbler and some sources" do
    setup do
      @sources = ["gems.rubyforge.org", Gem::AbstractCommand::URL]
      stub(Gem).sources { @sources }
      @command = Gem::Commands::TumbleCommand.new
    end

    should "show sources" do
      mock(@command).say("Your gem sources are now:")
      mock(@command).say("- #{@sources.first}")
      mock(@command).say("- #{Gem::AbstractCommand::URL}")
      @command.show_sources
    end
  end

  context "tumbling the gem sources" do
    setup do
      @sources = ["http://rubyforge.org"]
      stub(Gem).sources { @sources }
      @config = Object.new
      stub(Gem).configuration { @config }

      @command = Gem::Commands::TumbleCommand.new
    end

    should "add gemcutter as first source" do
      mock(@sources).unshift(Gem::AbstractCommand::URL)
      mock(@config).write

      @command.tumble
    end

    should "remove gemcutter if it's in the sources" do
      mock(@sources).include?(Gem::AbstractCommand::URL) { true }
      mock(@config).write
      mock(@sources).delete(Gem::AbstractCommand::URL)

      @command.tumble
    end
  end

  context "executing the tumbler" do
    setup do
      @command = Gem::Commands::TumbleCommand.new
    end

    should "say thanks, tumble and show the sources" do
      mock(@command).say(anything)
      mock(@command).tumble
      mock(@command).show_sources

      @command.execute
    end
  end
end
