class User < ActiveRecord::Base
	cattr_accessor :current
end

class WithCreated < ActiveRecord::Base
end

class WithoutCreated < ActiveRecord::Base
end
