require 'rails_helper'

describe BotsController do
  describe 'GET index' do
    it 'should render the index template' do
      User.create(id: 5, username: "User 1", password: "123")
      get(:index, session: {'user_id' => 5})
      expect(response).to render_template('index')
    end
  end

  describe 'POST #create' do
    it 'creates a new bot' do
      User.create(id: 5, username: "User 1", password: "123")
      expect {post :create, params: {bot: {name: "Bobby", ema: 9, bb: 60,  short: "true"}}, session: {'user_id' => 5}
      }.to change { Bot.count }.by(1)
    end
  end

  describe 'show' do
    it 'should redirect to home if not logged in' do
      bot = Bot.create(name: "Bobby", ema: 9, bb: 60,  short: "true")
      get :show, params: {id: bot.id}
      expect(response).to redirect_to(root_path)
    end
    it 'should redirect to bot page if logged in as wrong user' do
      userCorrect = User.create(id: 5, username: "UserC", password: "123")
      userWrong = User.create(id: 6, username: "UserW", password: "123")
      bot = Bot.create(name: "Bobby", ema: 9, bb: 60,  short: "true", username: userCorrect.username)
      get :show, params: {id: bot.id}, session: {'user_id' => userWrong.id}
      expect(response).to redirect_to(bots_path)
    end
    it 'should render the show template if logged in as correct user' do
      user = User.create(id: 5, username: "User 1", password: "123")
      bot = Bot.create(name: "Bobby", ema: 9, bb: 60,  short: "true", username: "User 1")
      BotOut.create(bot_id: bot.id)
      get :show, params: {id: bot.id}, session: {'user_id' => user.id}
      expect(response).to render_template('show')
    end
  end

  describe 'destroy' do
    it 'should delete the bot if correct user is logged in' do
      user = User.create(id: 5, username: "User 1", password: "123")
      bot = Bot.create(name: "Bobby", ema: 9, bb: 60,  short: "true", username: "User 1")
      expect {delete :destroy, params: {format: bot.id}, session: {'user_id' => user.id}}.to change { Bot.count }.by(-1)
    end
    it 'should not delete the bot if incorrect user is logged in' do
      userX = User.create(id: 1, username: "User X", password: "123")
      userY = User.create(id: 2, username: "User Y", password: "123")
      bot = Bot.create(name: "Bobby", ema: 9, bb: 60,  short: "true", username: "User X")
      expect {delete :destroy, params: {format: bot.id}, session: {'user_id' => userY.id}}.to change { Bot.count }.by(0)
    end
    it 'should redirect to root if no user is logged in' do
      bot = Bot.create(name: "Bobby", ema: 9, bb: 60,  short: "true")
      delete :destroy, params: {format: bot.id}
      expect(response).to redirect_to(root_path)
    end
  end
end
