require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe User do
  it 'should have a freaking user' do
		User.count > 0
	end
	it 'should have a curent_user set' do
		User.current.should == User.first
	end
end

describe WithCreated do
	it 'should set the created_by_id on create' do
		created = WithCreated.create!
		created.created_by_id.should == User.first.id
		created.updated_by_id.should == User.first.id
	end
	it 'can retrieve the created by' do
		created = WithCreated.create!
		created.created_by.should == User.first
		created.updated_by.should == User.first
	end
	it 'sets the updated by' do
		User.current = User.first
		created = WithCreated.create!
		User.current = User.last
		created.save!
		created.updated_by_id.should == User.first.id
		created.something = 'blah blah something else'
		created.save!
		created.created_by_id.should == User.first.id
		created.updated_by_id.should == User.last.id
		User.current = User.first
	end
end

describe WithoutCreated do
	it 'should set the created_by_id on create' do
		created = WithoutCreated.create!
		created.respond_to?(:created_by_id).should be_false
		created.respond_to?(:updated_by_id).should be_false
	end
	it 'can retrieve the created by' do
		created = WithoutCreated.create!
		created.created_by.should == nil
		created.updated_by.should == nil
	end
end