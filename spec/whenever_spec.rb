require 'rails_helper'

describe 'Whenever Schedule' do
  it "makes sure `runner` statements exist" do 
    schedule = Whenever::Test::Schedule.new(file: 'config/schedule.rb')
    
    assert_equal 1, schedule.jobs[:runner].count

    schedule.jobs[:runner].each { |job| instance_eval job[:task].split('.').first }
  end 
end
