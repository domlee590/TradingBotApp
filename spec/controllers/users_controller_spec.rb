require 'rails_helper'

describe UsersController do

  describe 'GET new' do
    it 'should render the new template' do
      get(:new)
      expect(response).to render_template('new')
    end
  end

  describe 'POST #create' do
    it 'creates a new user' do
      expect {post :create, params: {user: {username: "User 1", password: "123"}}
      }.to change { User.count }.by(1)
    end
    it 'rejects a duplicate username' do
      User.create(username: "User 1", password: "123")
      expect {post :create, params: {user: {username: "User 1", password: "123"}}
      }.to change { User.count }.by(0)
    end
  end

end
