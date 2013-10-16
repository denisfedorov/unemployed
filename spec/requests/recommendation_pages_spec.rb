# encoding: UTF-8
require 'spec_helper'

describe "Recommendation pages" do

  subject { page }

  describe "new page" do
    before do
      sign_in FactoryGirl.create(:user)
      visit new_recommendation_path
    end

    it { should have_title('Новая рекомендация') }
    it { should have_xpath("//input[@value='Добавить']") }

	  describe "new recommendation" do
    	let(:submit) { "Добавить" }
	    before do
	      fill_in "Услуга",         with: "Женская стрижка"
	      fill_in "Имя",        with: "Example User"
	      fill_in "Номер телефона",     with: "89038488888"
	      fill_in "E-mail", with: "user@example.com"
	      fill_in "Описание услуги", with: "Стрижка, окраска и все такое..." 
	    end

	    it "should create a service" do
	      expect { click_button submit }.to change(Service, :count).by(1)
	    end
	    it "should create a recommendation" do
	      expect { click_button submit }.to change(Recommendation, :count).by(1)
	    end
	  end

  end
end


