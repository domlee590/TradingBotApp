class BotRunController < ApplicationController
  def run
    name = "bob"
    ma1 = 1
    ma2 = 48
    short = "yes"
    @pythonbotrun = 'python3 lib/assets/paperTrading.py "#{name} #{ma1} #{ma2} #{short}"'
  end
end
