# encoding: UTF-8
require 'spec_helper'

describe "Recommendation pages" do

  before (:all) { @user=FactoryGirl.create(:user) }
  subject { page }

  describe "new page" do
    before do
      sign_in @user
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

  describe "index" do
    before do
      sign_in @user
      @user.recommendations.build(:service_id => FactoryGirl.create(:service, name: "Denis").id)
      @user.recommendations.build(:service_id => FactoryGirl.create(:service, name: "Lida").id)
      visit recommendations_path
    end

    it { should have_title('Мои рекомендации') }

	  describe "list user's recommendations" do
      before (:all) do
        30.times {@user.recommendations.build(:service_id => FactoryGirl.create(:service).id)}
      end
      after (:all) do
        Service.delete_all
      end

      let(:first_page)  { @user.recommendations.paginate(page: 1) }
      let(:second_page) { @user.recommendations.paginate(page: 2) }

      it { should have_link('Next') }
      its(:html) { should match('>2</a>') }

      it "should list each recommendation" do
        @user.recommendations.all[0..2].each do |rec|
          page.should have_selector('li', text: rec.service.name)
        end
      end

      it "should list the first page of recommendations" do
        first_page.each do |rec|
          page.should have_selector('li', text: rec.service.name)
        end
      end

      it "should not list the second page of recommendations" do
        second_page.each do |rec|
          page.should_not have_selector('li', text: rec.service.name)
        end
      end

      describe "showing the second page" do
        before { visit recommendations_path(page: 2) }

        it "should list the second page of recommendations" do
          second_page.each do |rec|
            page.should have_selector('li', text: rec.service.name)
          end
        end
      end 
    end

  end
end


