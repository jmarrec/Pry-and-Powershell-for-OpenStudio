# Pry-theme

You need pry, and pry-theme, as well as 'os' (you might need to install the ruby DevKit before).

```
gem install pry
gem install pry-theme
gem install os
```

Then you'll need to paste the theme at `%userprofile%\.pry\themes\jmarrec-16.prytheme.rb`

The pry-theme I created just defines color that goes with a white terminal. It is only useful on Windows (and will be loaded via the `.pryrc` file only if you are on Windows).
The Windows terminal doesn't support 256 bits colors and has terrible defaults. On Unix (macOS or Linux), the default is just fine as is.

![Pry Theme Colors](/doc/pry-theme-colors.png)

# PowerShell Profile

This file is located at `%userprofile%\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1`.
if it doesn't exist, which is likely the case, you'll need to create it.

Open PowerShell and enter `Test-Path $Profile` to see if you have already got a profile.
If you don't have one, to create one enter:

    New-Item –Path $Profile –Type File –Force
    
(You might need to use `New-Item -Path $profile -ItemType "file" -Force` instead).
    
Typing `$Profile` will give you the full path.

Enable scripts: `Set-ExecutionPolicy Unrestricted -Scope CurrentUser`

**Note:** if you keep getting a security warning when you launch powershell, go to `%userprofile%\Documents\WindowsPowerShell\` in Windows Explorer, right click on `Microsoft.PowerShell_profile.ps1`, "Properties" > "Unlock"

The only thing the powershell profile does is to change the appearance of the powershell window (white bg with black font) + its title via aliases (when I have several powershell open, I like to have a different title)
There is also an example at the end with an alias to launch another file in  `C:\Ruby22-x64\lib\ruby\site_ruby`. For example I have two: openstudio.rb which points to OpenStudio 2.4.0 currently, openstudio-rc which points to a friendly build that I installed.

* openstudio.rb: 

```
require 'C:\openstudio-2.4.0\Ruby\openstudio.rb'
```

* openstudio-rc.rb: 

```
require 'C:\openstudio-2.4.1\Ruby\openstudio.rb'
```


In the PowerShell Profile I defined three aliases and corresponding actions. Only the first one is really needed.

* `os`: launches pry, sets the terminal to white background and black font and sets the title of the terminal window to "OpenStudio"
* `osdebug`: same as above except it sets the title "DEBUG - OpenStudio - DEBUG". I find that useful sometimes when I have two terminal windows open, one in which I actually modify the model interactively, and the other that's simply my test bed to find methods, etc.
* `osrc`: launches pry and requires  `openstudio-rc.rb`, sets the background to black and text to white and title to ”OpenStudio Release Candidate”

That means I can then launch Powershell, cd to the directory of my choosing and type "os" to start my session. When pry gets called, the `.pryrc file is triggered `

# .pryrc

This file is located at `%userprofile%/.pryrc`.

The `.pryrc file` loads the pry-theme I created and makes the prompt show you the last level directory.

But more importantly it allows you to automatically require some modules, to add some functions or classes that you use often.

This is some commented out code at the beginning that will ask you a question about which version you want to load.

Note: I have hardcoded the path to my local repository of `openstudio-standards`. I find that very useful because I'm always messing with openstudio-standards in order to get it to do what I want.
You'll need to read and execute the steps in [DevelopperInformation > Setup](https://github.com/NREL/openstudio-standards/blob/master/docs/DeveloperInformation.md) if you want that too.
I also hardcoded the path `resources\modify_class_string_to_add_colors.rb` (in this directory). I suggest you adjust that!

![Change path in pryrc](/doc/change_path_in pryrc.png)

## One liner to load OpenStudio model

Because I just find it tedious to have to create a versionTranslator, then a loadModel, then verify if model exists or not, and that's definitely the action I do the most often, I just created a function called `os_load(path)` by adding this snippet to my `.pryrc` file

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


Let's see it in action in a terminal:   
 
    [1] (main)> model = osload('test.osm')
    => #<OpenStudio::Model::Model:0x0000000f86e598 @__swigtype__="_p_openstudio__model__Model">

    [2] (main)>model = osload('badpath.osm')
    RuntimeError: Path 'badpath.osm' is not a valid path to an OpenStudio Model

    
## Searching zones and spaces by partial name

`model.search_space(name, bool_puts=true)`
    


This will return a list of OpenStudio::Model::Space and can also print the name of each space found for your convenience (if you want to use getSpaceByName on a specific space name after that)

Example: a model in which I have 2 spaces that include the string "lab" in them

    [3] (main)> lab_spaces = model.search_space('lab') # Default behavior is to also output the name of each found space
    LAB 1 Space
    LAB 2 Space
    => [#<OpenStudio::Model::Space:0x0000000f5da070 @__swigtype__="_p_openstudio__model__Space">,
     #<OpenStudio::Model::Space:0x0000000f5d9da0 @__swigtype__="_p_openstudio__model__Space">,

**I have a single space that contains "rest" in its name**

This Will return an OpenStudio::Model::Space right away

    [4] (main)>space = model.search_space('rest')
    => #<OpenStudio::Model::Space:0x000000103196a0 @__swigtype__="_p_openstudio__model__Space">

`model.search_zone(name, bool_puts=true)` behaves exactly the same
    
## Test String format

Because I do almost of majority of things - geometry aside - in my model directly in a terminal window, I wanted to emulate the runner.registerXXX functions of OpenStudio measures so that some statements pop up.

    puts "This is an error message".error
    puts "This is a success message".success
    puts "This is a warning".warning
    puts "This is just an info".info
    puts "I'm going crazy with ugly colors because I can!".upcase.bg_magenta.cyan
    
    
![Test string class](/doc/test_string_class.png)

Note: if you want to modify that, see `resources\modify_class_string_to_add_colors.rb` which contains a `colortable` function that will help...

![Test string class](/doc/colortable_function.png)


## Cast a ModelObject to what it actually is

    [4] (main)> x = model.getModelObjects[10]
    x.class
    => OpenStudio::Model::ModelObject
    [5] (main)>x = x.to_actual_object
               x.class
    => OpenStudio::Model::ShadingSurface
    

# Installing everything automatically

You'll find a `copy_to_loc.bat` - **WINDOWS ONLY** - file which will copy the three main files in the right location. Just double click on it.

You can always just do it manually...


----

### Contact and Contribution

**Happy modeling and don't hesitate to reach out to me for any bugs or comments.**

I'll also welcome pull requests.
