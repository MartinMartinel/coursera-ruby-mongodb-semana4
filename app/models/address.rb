require 'pp'

class Address

  attr_accessor :city, :state, :location

  #let(:hash) {{ :type=>"Point", :coordinates=>[lon0, lat0] }}
  #let(:address_hash) {{ :city=>city, :state=>state, :loc=>hash }}

  def initialize city=nil, state=nil, loc=nil
    @city = city
    @state = state
    @location = Point.new(loc[:coordinates][0], loc[:coordinates][1]) if loc && loc[:coordinates]
  end

  def mongoize
    {:city=>@city, :state=>@state, :loc=>@location.mongoize}
  end

  def self.mongoize(object) 
    case object
      when Address then object.mongoize
      when Hash then 
        Address.new(object[:city], object[:state], object[:loc]).mongoize
      when nil then nil
    end
  end  

  def self.demongoize object
    case object
      when nil then nil
      when Hash then
        Address.new(object[:city], object[:state], object[:loc]) 
      when Address then object       
    end
  end

  def self.evolve object
    case object
      when nil then nil
      when Hash then object
      when Address then object.mongoize
    end
  end

end