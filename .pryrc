print "Do you want OpenStudio (os) or OpenStudio Release Candidate (rc): [os/osrc] "
input = gets.strip

if input == "os"
    require 'openstudio'
else
    require 'openstudio-rc'
end

#require 'csv'
#require 'json'

# Load my local repo of openstudio-standards - CHANGE IT TO MATCH YOUR INSTALL
require 'D:\Software\Others\openstudio-standards\openstudio-standards\lib\openstudio-standards.rb'

# Load my class to emulate runner.registerError("error message") etc with puts "error message".error
require 'D:\Software\Pry and Powershell for OpenStudio\resources\modify_class_string_to_add_colors.rb'

Pry.config.theme = "jmarrec-16" 

Pry.config.prompt_name = File.basename(Dir.pwd)


# Helper to load a model in one line
def osload(path)
  translator = OpenStudio::OSVersion::VersionTranslator.new
  ospath = OpenStudio::Path.new(path)
  model = translator.loadModel(ospath)
  if model.empty?
      raise "Path '#{path}' is not a valid path to an OpenStudio Model"
  else
      model = model.get
  end  
  return model
end

# Extend ModelObject class to add a to_actual_object method
# Casts a ModelObject into what it actually is (OS:Node for example...)
class OpenStudio::Model::ModelObject
  def to_actual_object
    obj_type = self.iddObjectType.valueName
    obj_type_name = obj_type.gsub('OS_','').gsub('_','')
    method_name = "to_#{obj_type_name}"
    if self.respond_to?(method_name)
      actual_thing = self.method(method_name).call
      if !actual_thing.empty?
          return actual_thing.get
      end
    end
    return false
  end
end

# Open Model Class to add helper functions
class OpenStudio::Model::Model
  # Search current model by supplying a case insensitive string
  # Loops on each space, and if the space include the string, it's added to a list
  # If there's only one space, returns an actual space instead of a list of spaces
  def search_space(name, bool_puts=true)
    matching_spaces = []
    self.getSpaces.each do |space|
      if space.name.to_s.downcase.include?(name.downcase)
        matching_spaces << space
      end
    end
    
    if matching_spaces.size == 1
      return matching_spaces[0]
    else
      if bool_puts
        matching_spaces.each do |space|
          puts space.name
        end
      end
      return matching_spaces
    end
  end

  def search_zone(name, bool_puts=true)
    matching_zones = []
    self.getThermalZones.each do |zone|
      if zone.name.to_s.downcase.include?(name.downcase)
        matching_zones << zone
      end
    end
    
    if matching_zones.size == 1
      return matching_zones[0]
    else
      if bool_puts
        matching_zones.each do |zone|
          puts zone.name
        end
      end
      return matching_zones
    end
  end
end
