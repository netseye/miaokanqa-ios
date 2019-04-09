$LOAD_PATH << File.expand_path('../../', __FILE__)
$LOAD_PATH << File.expand_path('../../support', __FILE__)

require 'spec_helper'
require 'event_helper'

describe 'app login' do
  before :all do

  end

  it 'show guide page' do
    swipe_left 3
    click_by_button_name '立即体验'
    click_by_name '我的'      
  end
  
  context "when show login page" do
    it "should two textfiled" do
      click_by_name 'MKMyLoginPhone'
      expect(should_have_textfield('请输入11位手机号码').nil?).to eq false
      expect(should_have_textfield('请输入密码').nil?).to eq false
    end
  
    it "mobile textfeld maxlegth 11" do
      fill_in_by_textfield_value '请输入11位手机号码', with:'1381158888'
      expect(should_have_textfield('1381158888').nil?).to eq false
    end

    it "should be login success" do
      fill_in_by_textfield_value '请输入密码', with:'88888888'
      click_by_button_name '登录'
      expect(should_have_text('观看记录').nil?).to eq false
    end
    
    it "test faield smaple" do
      expect(should_have_text('观看记录!').nil?).to eq false
    end
  end
end