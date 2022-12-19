require 'rails_helper'

describe EdusController do
  describe 'GET index' do
    it 'should render the index template' do
      User.create(id: 5, username: "User 1", password: "123")
      get(:index, session: {'user_id' => 5})
      expect(response).to render_template('index')
    end
  end

  describe 'show' do
    it 'should render blank show template if not fetch' do
      User.create(id: 5, username: "User 1", password: "123")
      edu = Edu.create(name: "Bobby", ema: 9, bb: 60,  short: "true")
      get :show, params: {id: edu.id, fetch: false}, session: {'user_id' => 5}
      expect(response).to render_template('show')
    end
    it 'should render full show template if fetch' do
      User.create(id: 5, username: "User 1", password: "123")
      edu = Edu.create(name: "Bobby", ema: 9, bb: 60,  short: "true")
      EduOut.create(edu_id: edu.id)
      get :show, params: {id: edu.id, fetch: true}, session: {'user_id' => 5}
      expect(response).to render_template('show')
    end
  end

  describe 'copybot' do
    it 'should copy bot for user if logged in' do
      User.create(id: 5, username: "User 1", password: "123")
      edu = Edu.create(name: "Bobby", ema: 9, bb: 60,  short: "true")
      expect {get :copybot, params: {format: edu.id}, session: {'user_id' => 5}}.to change { Bot.count }.by(1)
    end
  end

end