require 'spec_helper'

describe HomeController do
  describe "GET 'index'" do
    context 'user not signed in' do
      before { get :index }
      subject { response }
      it do
        should render_template('index')
        should be_success
      end
    end
    context 'user signed in' do
      login_user
      before { get :index }
      subject { response }
      it do
        should render_template('index_signed_in')
        should be_success
      end
    end
  end
end
