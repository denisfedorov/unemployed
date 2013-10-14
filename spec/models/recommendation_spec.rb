# encoding: UTF-8
require 'spec_helper'

describe Recommendation do
  let(:user)  { FactoryGirl.create(:user) }
  let(:service) { FactoryGirl.create(:service)}
  let(:recommendation) { user.recommendations.build(service_id: service.id, comment: "Очень хороший сервис!")}

  subject { recommendation }
  it {should be_valid}

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Recommendation.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "service methods" do
    it { should respond_to(:service) }
    it { should respond_to(:user) }
    its(:service) { should == service }
    its(:user) { should == user }
  end

  describe "when service id is not present" do
    before { recommendation.service_id = nil }
    it { should_not be_valid }
  end

  describe "when user id is not present" do
    before { recommendation.user_id = nil }
    it { should_not be_valid }
  end

end
