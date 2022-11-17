require 'rails_helper'

describe BotsController do
  describe 'GET index' do
    it 'should render the index template' do
      user = User.create(id: 5, username: "User 1", password: "123")
      get(:index, session: {'user_id' => 5})
      expect(response).to render_template('index')
    end
  end

  describe 'POST #create' do
    it 'creates a new bot' do
      user = User.create(id: 5, username: "User 1", password: "123")
      expect {post :create, params: {bot: {name: "Bobby", ema: 9, bb: 60,  short: "true"}}, session: {'user_id' => 5}
      }.to change { Bot.count }.by(1)
    end
  end

  describe 'show' do
    it 'should render the show template' do
      bot = Bot.create(name: "Bobby", ema: 9, bb: 60,  short: "true")
      get :show, params: {id: bot.id}
      expect(response).to render_template('show')
    end
  end

  describe 'destroy' do
    it 'should delete the bot' do
      bot = Bot.create(name: "Bobby", ema: 9, bb: 60,  short: "true")
      bot_output = BotOutput.create(bot_id: bot.id, pnl: 10)
      expect {delete :destroy, params: {format: bot.id}
      }.to change { Bot.count }.by(-1)
    end
  end

end
