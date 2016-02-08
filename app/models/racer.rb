class Racer
  include Mongoid::Document
  include Mongoid::Timestamps

  Mongo::Logger.logger.level = ::Logger::INFO

  embeds_one :info, as: :parent, class_name: 'RacerInfo', autobuild: true

  delegate :first_name, :first_name=, to: :info
  delegate :last_name, :last_name=, to: :info
  delegate :gender, :gender=, to: :info
  delegate :birth_year, :birth_year=, to: :info
  delegate :city, :city=, to: :info
  delegate :state, :state=, to: :info

  before_create do |racer|
    racer.info.id = racer.id
  end

end
