require "spec_helper"
require "ostruct"

describe FirstClickFree::Concerns::Controller, type: :controller do
  context "standard controller" do
    controller do
      allow_first_click_free

      def index
        head :ok
      end
    end

    context "first visit" do
      before { get :index }
      it { session[:first_click].should_not be_nil }
      it { response.should be_success }
    end

    context "subsequent visit" do
      before { session[:first_click] = Time.zone.now }
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