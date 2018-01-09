ECHO "Copying all files to the correct location"

COPY "Microsoft.PowerShell_profile.ps1" "%userprofile%\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"

COPY ".pryrc" "%userprofile%\.pryrc" 

IF NOT EXIST "%userprofile%\.pry\themes\" MKDIR "%userprofile%\.pry\themes\
COPY "jmarrec-16.prytheme.rb" "%userprofile%\.pry\themes\jmarrec-16.prytheme.rb" 

PAUSE
