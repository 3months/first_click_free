require "spec_helper"
require "ostruct"

Rails.application.routes.draw do
  match "/first-click-free" => "anonymous#index", :as => "first_click_free", :via => "get"
end


describe FirstClickFree::Concerns::Controller, type: :controller do

  let(:current_url) { "http://test.host/first-click-free" }

  context "standard controller" do
    controller do
      allow_first_click_free

      def index
        head :ok
      end
    end


    context "first visit" do
      before { get :index, test: true }
      it { session[:first_click].should eq current_url }
      it { response.should be_success }
    end

    context "subsequent visit to same page" do
      before { session[:first_click] = current_url }
      it { expect { get :index }.to_not raise_error FirstClickFree::Exceptions::SubsequentAccessException }
    end

    context "subsequent visit to different page" do
      before { session[:first_click] = "http://test.host/another-page" }
      it { expect { get :index }.to raise_error FirstClickFree::Exceptions::SubsequentAccessException }
    end

    context "googlebot visit" do
      before { controller.stub(:googlebot? => true); get :index }
      it { session[:first_click].should be_nil }
      it { response.should be_success }
    end

    context "registered user vist" do
      before { controller.stub(:user_for_first_click_free => true); get :index }
      it { session[:first_click].should be_nil }
      it { response.should be_success }
    end

    context "google referrer visit" do
      before { get :index; controller.stub(permitted_domain?: true); get :index }
      it { response.should be_success }
    end
  end

  context "controller skipping an action" do
    controller do
      allow_first_click_free except: :index

      def index
        head :ok
      end
    end

    before { get :index }
    it { session[:first_click].should be_nil }
    it { response.should be_success }
  end

  context "entire controller skipped" do
    controller do

      # Normally this would be done in ApplicationController or similar
      allow_first_click_free

      # And this would be done in a child controller
      skip_first_click_free

      def index
        head :ok
      end
    end

    before { get :index }
    it { session[:first_click].should be_nil }
    it { response.should be_success }
  end
end