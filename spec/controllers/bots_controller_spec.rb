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
    it 'should render the show template if logged in' do
      user = User.create(id: 5, username: "User 1", password: "123")
      bot = Bot.create(name: "Bobby", ema: 9, bb: 60,  short: "true", username: "User 1")
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
  end
end
