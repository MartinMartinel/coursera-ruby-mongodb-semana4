class Entrant

  include Mongoid::Document
  include Mongoid::Timestamps
  #include Mongoid::Attributes::Dynamic

  store_in collection: "results"

  field :bib, as: :bib, type: Integer
  field :secs, as: :secs, type: Float
  field :o, as: :overall, type: Placing
  field :gender, as: :gender, type: Placing
  field :group, as: :group, type: Placing

  embeds_many :results, as: :parent, class_name: "LegResult", after_add: :update_total , after_remove: :update_total
  embeds_one :race, class_name: 'RaceRef', autobuild: true
  embeds_one :racer, class_name: 'RacerInfo', as: :parent, autobuild: true  

  default_scope ->{order_by(:"event.o".desc)}
  scope :upcoming, ->{where(:'race.date'.gte => Date.current)}
  scope :past, ->{where(:'race.date'.lt => Date.current)}

  #delegate :first_name, :first_name=, to: :racer
  #delegate :last_name, :last_name=, to: :racer
  #delegate :gender, :gender=, to: :racer, prefix: "racer"
  #delegate :birth_year, :birth_year=, to: :racer
  #delegate :city, :city=, to: :racer
  #delegate :state, :state=, to: :racer

  def update_total(result)
    self.secs = 0
    self.results.each do |result|        
      if result.secs
        self.secs = self.secs + result.secs
      end
    end
  end

  def the_race
    race.race
  end

  #def overall_place
  #  overall.place if overall
  #end

  #def gender_place
  #  gender.place if gender
  #end

  #def group_name
  #  group.name if group
  #end

  #def group_place
  #  group.place if group
  #end

end