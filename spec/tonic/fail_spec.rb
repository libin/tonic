require 'tonic'

describe Tonic, '#not_working' do
  it 'really not working yet' do
    raise 'Soon it will work'
    Tonic::VERSION.should == '0.0.2'
  end
end
