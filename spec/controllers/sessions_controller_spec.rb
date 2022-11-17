require 'rails_helper'

describe SessionsController do
  describe 'GET new' do
    it 'should render the new template' do
      get(:new)
      expect(response).to render_template('new')
    end
  end

  describe 'POST #create' do
    it 'should create a new session with valid user' do
      user = User.create(username: "User 1", password: "123")
      post :create, params: {username: "User 1", password: "123"}
      expect(session[:user_id]).to eq(user.id)
    end
    it 'should not create a new session with invalid user' do
      User.create(username: "User 1", password: "123")
      post :create, params: {username: "User 1", password: "1234"}
      expect(session[:user_id]).to eq(nil)
    end
  end

  describe 'GET #logout' do
    it 'should destroy the session' do
      User.create(id: 5, username: "User 1", password: "123")
      get(:logout, session: {user_id: 5})
      expect(session[:user_id]).to eq(nil)
    end
  end

end