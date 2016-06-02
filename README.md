# Pry-theme

You need pry, and pry-theme (`gem install pry-theme`, you might need to install the DevKit before)

Then you'll need to paste the theme at `%userprofile%\.pry\themes\jmarrec-16.prytheme.rb`

The pry-theme I created just defines color that goes with a white terminal. 

![Pry Theme Colors](/doc/pry-theme-colors.png)

# PowerShell Profile

This file is located at `%userprofile%\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1` (if it doesn't exist, which is likely the case, you'll just create it when pasting the file)

The powershell profile defines some aliases to launch the right version of openstudio that you need: you can have several files in your `C:\Ruby200-x64\lib\ruby\site_ruby`. For example I have two: openstudio.rb which points to OpenStudio 1.1.13 currently and openstudio-rc which points to my local build of OpenStudio (when compiling the source code).

* openstudio.rb: 

    require 'C:\Program Files\OpenStudio 1.11.3\Ruby\openstudio.rb'

* openstudio.rc: 

    require 'D:\OpenStudio\build\OSCore-prefix\src\OSCore-build\ruby\Debug\openstudio.rb'

In the PowerShell Profile I defined three aliases and corresponding actions:

* `os`: launches pry and requires openstudio.rb, sets the terminal to white background and black font and sets the title of the terminal window to "OpenStudio 1.1.13"
* `osdebug`: same as above except it sets the title "DEBUG - OpenStudio 1.11.3 - DEBUG". I find that usefull sometimes when I have two terminal windows open, one in which I actually modify the model interactively, and the other that's simply my test bed to find methods, etc.
* `osrc`: launches pry and requires  `openstudio-rc.rb`, sets the background to black and text to white and title to ”OpenStudio Release Candidate”

That means I can then launch Powershell, cd to the directory of my choosing and type "os" to start my session. When pry gets called, the `.pryrc file is triggered `

# .pryrc

This file is located at `%userprofile%/.pryrc`.

The `.pryrc file` loads the pry-theme I created and makes the prompt show you the last level directory.

But more importantly it allows you to automatically require some modules, to add some functions or classes that you use often.

Note: I have hardcoded the path to my local repository of `openstudio-standards`. I find that very useful because I'm always messing with openstudio-standards in order to get it to do what I want.
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


# Cast a ModelObject to what it actually is

    [4] (main)> x = model.getModelObjects[10]
    x.class
    => OpenStudio::Model::ModelObject
    [5] (main)>x = x.to_actual_object
               x.class
    => OpenStudio::Model::ShadingSurface
    

# Installing everything automatically

You'll find a `copy_to_loc.bat` file which will copy the three main files in the right location. Just double click on it.

You can always just do it manually...


----

### Contact and Contribution

**Happy modeling and don't hesitate to reach out to me for any bugs or comments.**

I'll also welcome pull requests.
