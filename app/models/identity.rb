class Identity < ApplicationRecord
  belongs_to :handle
  enum kind: [:hn]

end
