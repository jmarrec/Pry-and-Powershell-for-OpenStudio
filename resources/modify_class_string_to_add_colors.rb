# Monkey-patch the String class to add formatters for terminal text
# And a few helper functions for warning, error, success and info
class String
  def black;          "\e[30m#{self}\e[0m" end
  def red;            "\e[31m\e[1m#{self}\e[22m\e[0m" end
  def green;          "\e[32m#{self}\e[0m" end
  def yellow;         "\e[33m\e[1m#{self}\e[22m\e[0m" end
  def blue;           "\e[34m\e[1m#{self}\e[22m\e[0m" end
  def magenta;        "\e[35m\e[1m#{self}\e[22m\e[0m" end
  def cyan;           "\e[36m#{self}\e[0m" end
  def gray;           "\e[37m#{self}\e[0m" end
  def white;           "\e[37m\e[1m#{self}\e[22m\e[0m" end

  def bg_black;       "\e[40m#{self}\e[0m" end
  def bg_red;         "\e[41m#{self}\e[0m" end
  def bg_green;       "\e[42m#{self}\e[0m" end
  def bg_yellow;      "\e[43m#{self}\e[0m" end
  def bg_blue;        "\e[44m#{self}\e[0m" end
  def bg_magenta;     "\e[45m#{self}\e[0m" end
  def bg_cyan;        "\e[46m#{self}\e[0m" end
  def bg_white;        "\e[47m#{self}\e[0m" end
  
  def self.colors
    puts "Colors:                 Backgrounds:"
    puts "--------                -------------"
    puts "black".black + " "*19 + "bg_black".bg_black
    puts "red".red + " "*21 + "bg_red".bg_red
    puts "green".green + " "*19 + "bg_green".bg_green
    puts "yellow".yellow + " "*18 + "bg_yellow".bg_yellow
    puts "blue".blue + " "*20 + "bg_blue".bg_blue
    puts "magenta".magenta + " "*17 + "bg_magenta".bg_magenta
    puts "cyan".cyan + " "*20 + "bg_cyan".bg_cyan
    puts "gray".gray + " "*20 + "bg_white".bg_white
    puts "white (on black bg)".white.bg_black
  end
  
  def warning
    "/i\\:".bg_yellow + " #{self}"
  end
  
  def error
    "Error:".bg_red.yellow + " #{self}"
  end
  
  def success
    "Success:".bg_green  + " #{self}"
  end
  
  def info
    "Info:".bg_cyan  + " #{self}"
  end
  
  
end