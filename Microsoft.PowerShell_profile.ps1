# Start in C: directory = Set to your own needs
set-location c:

# Bind $Shell to $Host.UI.RawUI (hard to remember)
$Shell = $Host.UI.RawUI
# The following would make ALL powershell windows to display "OpenStudio"
#$Shell.WindowTitle=”OpenStudio”

# create aliases binded to function that will change the title and launch pry with the correct require statement
# "os", "osrc", etc after New-Alias is defined in 
# Current release of OpenStudio
Function Set-Title-OS {
  $Shell.BackgroundColor = “White”;
  $Shell.ForegroundColor = “Black”;
  Clear-Host;
  $Shell.WindowTitle=”OpenStudio 1.12.1”;
  pry -r 'openstudio'
 }
New-Alias os Set-Title-OS


##############################################
# These two below aren't necesarilly needed

# Current release of OpenStudio - for debug purpose, helps identifying when you open two terminals at the same time on the same model
Function Set-Title-OSDEBUG {
  $Shell.BackgroundColor = “White”;
  $Shell.ForegroundColor = “Black”;
  Clear-Host;
  $Shell.WindowTitle=”DEBUG - OpenStudio - DEBUG”;
  pry
}
    New-Alias osdebug Set-Title-OSDEBUG
    
# Additional release of OpenStudio
# I added another file here: C:\Ruby200-x64\lib\ruby\site_ruby\openstudio-rc.rb that will require my local OpenStudio build after I make changes in source C++ code
# Could also require another version of openstudio than the current (1.11.2 for example)
# You'll notice that here I've set the background to black and font to white... the opposite of usual.
Function Set-Title-OSRC {$Shell.BackgroundColor = “Black”; $Shell.ForegroundColor = “White”; Clear-Host; $Shell.WindowTitle=”OpenStudio Release Candidate”; pry --require 'openstudio-rc'}
    New-Alias osrc Set-Title-OSRC