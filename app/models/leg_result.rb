class LegResult
  include Mongoid::Document
  include Mongoid::Timestamps

  field :secs, as: :secs, type: Float

  embedded_in :entrant
  embeds_one :event, as: :parent

  validates :event, presence: true

  def calc_ave
  end

  after_initialize :calc_ave

  def secs=value
    self[:secs] = value
    self.calc_ave
  end
end
