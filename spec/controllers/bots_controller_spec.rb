require 'rails_helper'

describe BotsController do
  describe 'GET index' do
    it 'should render the index template' do
      get :index
      expect(response).to render_template('index')
    end
  end

  describe 'POST #create' do
    it 'creates a new bot' do
      expect {post :create, params: {bot: {name: "Bobby", movingAverage1: 9, movingAverage2: 60, short: "yes"}}
      }.to change { Bot.count }.by(1)
    end
  end

  describe 'GET #edit' do
    it 'should render the edit template' do
      bot = Bot.create(name: "Bobby", movingAverage1: 9, movingAverage2: 60, short: "yes")
      get :edit, params: {id: bot.id}
      expect(response).to render_template('edit')
    end
  end

  describe 'PUT #update' do
    it 'should update the bot' do
      bot = Bot.create(name: "Bobby", movingAverage1: 9, movingAverage2: 60, short: "yes")
      put :update, params: {id: bot.id, bot: {name: "Bob"}}
      expect(bot.reload.name).to eq("Bob")
    end
  end

  describe 'show' do
    it 'should render the show template' do
      bot = Bot.create(name: "Bobby", movingAverage1: 9, movingAverage2: 60, short: "yes")
      get :show, params: {id: bot.id}
      expect(response).to render_template('show')
    end
  end

end
