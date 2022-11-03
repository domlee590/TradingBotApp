require 'spec_helper'
require 'bots_controller'

describe BotsController do
  describe 'create', :pending => true do
    it "takes a name, two MA values and a boolean short value and returns a bot" do
      @bot = BotsController.create("Bobby", 9, 60, "yes")
      expect(@bot).to be_an_instance_of(BotsController)
    end
  end
end