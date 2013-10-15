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

  end
end


