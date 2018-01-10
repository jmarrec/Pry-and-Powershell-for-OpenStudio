# Either you always require openstudio, or if you use several versions and/or local build, you can comment out the
# line just below and comment the =begin =end to ask the user to specify which to import

require 'openstudio'
puts "Loading installed openstudio"
require 'os'

=begin
if OS.mac?

  print "Do you want OpenStudio (os) or local Debug build (1) or local Release build (2)): [os/1/2] "
  input = gets.strip

  # This typically loads a custom build installed on my computer
  if input == '1'
    p = File.join(ENV["HOME"], "Software/Others/OS-build/Products/ruby/openstudio")
  elsif input == '2'
    p = '/Volumes/Data/Software/OS-build/Products/ruby/openstudio'
  elsif input == 'dr'
    p = '/Volumes/Data/Software/Release/Products/ruby/openstudio'
  else
    p = 'openstudio'
  end

elsif OS.linux?
  print "Do you want OpenStudio (os) or local Debug build (1) or Data-Debug (2): [os/1/2] "
  input = gets.strip

  # This typically loads a custom build installed on my computer
  if input == '1'
    p = File.join(ENV["HOME"], "Software/Others/OS-build/Products/ruby/openstudio")
  elsif input == '2'
    p = File.join(ENV["HOME"], "Software/Others/OS-build2/Products/ruby/openstudio")
  else
    p = 'openstudio'
  end

elsif OS.windows?
  puts "Not implemented for windows yet - requiring installed one"
  p = 'openstudio'

  if input == '1'
    p = File.join(ENV["HOME"], "Software/Others/OS-build/Products/ruby/openstudio")
  elsif input == '2'
    p = File.join(ENV["HOME"], "Software/Others/OS-build2/Products/ruby/openstudio")
  else
    p = 'openstudio'
  end
  
else
    puts "Unrecognized OS"
    p = 'openstudio'
end

require p
puts "Loading '#{p}'"

=end



# I typically use CSV a lot, so I generally import it all the time
require 'csv'
#require 'json'

# Load my local repo of openstudio-standards - CHANGE IT TO MATCH YOUR INSTALL
#require 'D:\Software\Others\openstudio-standards\openstudio-standards\lib\openstudio-standards.rb'

p = File.join(ENV['HOME'], 'Software/Others/openstudio-standards/lib/openstudio-standards.rb')
if File.exists?(p)
  require p
  puts "Loading local openstudio-standards: #{p}"
  puts "\n"
else
  puts "Cannot find local openstudio-standards"
end


# Load my class to emulate runner.registerError("error message") etc with puts "error message".error
# You need to change the path to it.
#require 'C:\Users\Julien\Documents\Software\Pry-and-Powershell-for-OpenStudio\resources\modify_class_string_to_add_colors.rb'
require File.join(ENV['HOME'], 'Software/Pry-and-Powershell-for-OpenStudio/resources/modify_class_string_to_add_colors.rb')

# Load my custom pry-theme, useful for windows, on Unix the terminal is much better
if OS.windows?
  Pry.config.theme = "jmarrec-16"
end

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


    # Handle some weird cases with Materials...
    if obj_type_name == "MaterialAirGap"
      method_name = "to_AirGap"
    elsif obj_type_name == "MaterialAirWall"
      method_name = "to_AirWallMaterial"
    elsif obj_type_name == "MaterialNoMass"
      method_name = "to_MasslessOpaqueMaterial"
    elsif obj_type_name == "WindowMaterialBlind"
      method_name = "to_Blind"
    elsif obj_type_name == "WindowMaterialGlazing"
      method_name = "to_Glazing"
    elsif obj_type_name == "Material"
      method_name = "to_OpaqueMaterial"

    # Common case
    else
      method_name = "to_#{obj_type_name}"
    end

    if self.respond_to?(method_name)
      actual_thing = self.method(method_name).call
      if !actual_thing.empty?
          return actual_thing.get
      end
    else
    puts "Object doesn't respond to '#{method_name}'"
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

# Set the Log Level to Info by default (otherwise it's OpenStudio::Warn)
OpenStudio::Logger.instance.standardOutLogger.enable
OpenStudio::Logger.instance.standardOutLogger.setLogLevel(OpenStudio::Info)

# Make a ft (this is useful for me when testing C++ code after building...)
ft = OpenStudio::EnergyPlus::ForwardTranslator.new

# I include this in order to be able to write code that looks closer to C++ when building tests
# I can do `m = Model.new` instead of `OpenStudio::Model::Model.new`
include OpenStudio::Model
