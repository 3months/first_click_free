require "spec_helper"

describe FirstClickFree::Concerns::Controller, type: :controller do
  controller do
    include described_class

    def index
      head :ok
    end
  end

  context "first visit" do
    before { get :index }
    it { session[:first_click].should_not be_nil }
    it { response.should be_success }
  end

  context "subsequent visit"
  context "googlebot visit"
end