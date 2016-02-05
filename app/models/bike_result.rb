class BikeResult < LegResult
  field :mph, as: :mph, type: Float

  def calc_ave
    if self.event && self.secs
      miles = self.event.miles
      self.mph = miles .nil? ? nil : miles*3600/self.secs
    end   
  end     
end