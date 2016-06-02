t = PryTheme.create :name => 'jmarrec-16', :color_model => 16 do
  author :name => 'Julien Marrec', :email => 'jmarrec@gmail.com'
  description 'To use with a Windows Powershell that has the background set to White'

  define_theme do
    class_ 'red'
    class_variable 'cyan'
    comment 'bright_black'
    constant 'bright_blue'
    error 'bright_yellow', 'red'
    float 'bright_magenta'
    global_variable 'bright_magenta'
    inline_delimiter 'green'
    instance_variable 'bright_blue'
    integer 'bright_red'
    keyword 'green'
    method 'bright_red'
    predefined_constant 'cyan'
    symbol 'green'

    regexp do
      self_ 'cyan'
      char 'green'
      content 'bright_red'
      delimiter 'bright_blue'
      modifier 'bright_red'
      escape 'green'
    end

    shell do
      self_ 'blue'
      char 'cyan'
      content 'blue'
      delimiter 'green'
      escape 'green'
    end

    string do
      self_ 'red'
      char 'bright_blue'
      content 'red'
      delimiter 'bright_magenta'
      escape 'green'
    end
  end
end

PryTheme::ThemeList.add_theme(t)
