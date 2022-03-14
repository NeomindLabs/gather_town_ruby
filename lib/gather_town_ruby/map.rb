class GatherTown::Map < Struct.new :collisions,                                                                 
                                   :foregroundImagePath,                                                        
                                   :walls,                                                                      
                                   :useDrawnBG,                                                                 
                                   :spawns,                                                                     
                                   :id,                                                                         
                                   :announcer,                                                                  
                                   :dimensions,                                                                 
                                   :updatedAt,                                                                  
                                   :objects,                                                                    
                                   :backgroundImagePath,                                                        
                                   :floors,                                                                     
                                   :assets,                                                                     
                                   :mostRecentUpdateId,                                                         
                                   :portals,
                                   :spaces,
                                   :objectSizes,
                                   :version

  def initialize(h)
    # transform the string keys in the hash (received from the Gather API)
    # into symbols, so as to match the Struct attributes defined above,
    # then initialize the Struct with the hash's data. 
    super *h.transform_keys(&:to_sym).values_at(*self.class.members)
    # cast updatedAt to DateTime
    @updatedAt = DateTime.parse(@updatedAt) unless @updatedAt.nil?
  end

  def to_json
    self.to_h.to_json
  end

  def text_objects(with_message: nil)
    obs = objects.select { |o| o["_name"] == "Text" }
    return (with_message ? obs.select { |o| o["properties"]["message"] == with_message} : obs)
  end

end