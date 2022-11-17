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
      expect {post :create, params: {bot: {name: "Bobby", ema: 9, bb: 60,  short: "true"}}
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

end
