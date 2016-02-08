class RacerInfo
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :fn, type: String, as: :first_name
  field :ln, type: String, as: :last_name
  field :g, type: String, as: :gender
  field :yr, type: Integer, as: :birth_year
  field :res, type: Address, as: :residence
  field :racer_id, as: :_id
  field :_id, default:->{ racer_id }

  embedded_in :parent, polymorphic: true

  validates :first_name, :last_name, presence: true
  validates :gender, inclusion: { in: ["M", "F"] } , presence: true
  validates :birth_year, numericality: {only_integer: true, less_than: Date.today.year} , presence: true

end
