class EditorState
  #routines for drawing windows and things in them.

  def w_update_cursor(x,y)
    "#{ESC}[#{y + @header_height};#{x}H"    
  end

  def w_clear
    return @c.reset
  end

  def fg(forground)

    out = String.new

    case forground
    when "red"
      out =  "[31m"
    when "RED"
      out  = "[;1;31m"
    when "green"
      out << "[32m"
    when "GREEN"
      out = "[;1;32m"
    when "blue"
      out  = "[34m"
    when "BLUE"
      out = "[;1;34m"
    when "cyan"
      out = "[36m"
    when "CYAN"
      out = "[;1;36m"
    when "magenta"
      out = "[35m"
    when "MAGENTA"
      out = "[;1;35m"
    when "yellow"
      out = "[33m"
    when "YELLOW"
      out = "[;1;33m"
    when "black"
      out = "[30m"
    when "BLACK"
      out = "[;1;30m"
    when "hide"
      out = "[?25l"
    when "show"
      out = "[?25h"
    when "reset"
      out = "[0m"

    end
    return out
  end

  def bg(background)

    out = String.new

    case background
    when "red"
      out =  "[41m"
    when "green"
      out = "[42m"
    when "blue"
      out  = "[44m"
    when "cyan"
      out = "[46m"
    when "magenta"
      out = "[45m"
    when "yellow"
      out = "[43m"
    when "black"
      out = "[40m"
    when "white"
      out = "[47m"
    end
    return out
  end

  def center(string,width,color)
    result = String.new
    outdash = ((width / 2 ) - (string.length / 2)) 
    outdash.times {result << " "}
    result << color if !color.nil?
    result << string
    (width - (outdash + string.length)).times {result << " "}
    return result
  end

  def make_window(startx,starty,width,height,forground,background,border,title)

    f_color = fg(forground)
    b_color = bg(background)
    bdr_color = bg(border)
    window = String.new

    window << w_update_cursor(startx,starty)
    window  << bdr_color
    window << center(title,width,nil)
    for i in 1..height  do
      window << w_update_cursor(startx,starty+i)
      window << bdr_color << " " << b_color
      (width - 2).times {window << " "}
      window << bdr_color << " "
      window << bg("white")  << " "  
    end
    window << w_update_cursor(startx,starty+height) << bdr_color
    width.times  {window << " "}
    window << w_update_cursor(startx+1,starty+height+1) << bg("white")
    width.times  {window << " "}
    window << w_update_cursor(startx,starty)

    return window
  end

  def help_window

    idt = 16
    str = 5
    width=58
    out = make_window(str,2,60,12,"BLACK","cyan","blue","Help Window")
    out << w_update_cursor(idt,str) << fg("yellow") << bg("cyan")
    out << "CTRL-A" << fg("white")  << " Abort Message" 
    out << w_update_cursor(idt,str+1) << fg("yellow") 
    out << "CTRL-L" << fg("white") << " Refresh Screen"   
    out << w_update_cursor(idt,str+2) << fg("yellow") 
    out << "CTRL-N" << fg("white") << " New Line"  
    out << w_update_cursor(idt,str+3) << fg("yellow") 
    out << "CTRL-X" << fg("white") << " Save (Post) Message"  
    out << w_update_cursor(idt,str+4) << fg("yellow") 
    out << "CTRL-Y" << fg("white") << " Delete Line"  
    out << w_update_cursor(idt,str+6) << fg("yellow") 
    out << "INSERT" << fg("white") << " Toggle Insert/Overwrite"  
    out << w_update_cursor(idt,str+8)
    out << "ESC to exit this window." << fg("white")
  end

  def splash_window

    idt = 15
    str = 8
    width = 38
    out = make_window(idt-1,str-1,40,8,"WHITE","magenta","cyan","About")
    out << w_update_cursor(idt,str+1) <<fg("yellow")  << bg("magenta")
    out << center("QUARKedit #{VERSION}",width,fg("white"))
    out << w_update_cursor(idt,str+3)
    out << center("By Dossy and Mark Firestone",width,fg("white"))
    out << w_update_cursor(idt+36,str+7)
    #out << fg("hide")
  end

  def yes_no_window(question)
    idt = 11
    str = 10
    w_width = question.length + 14
    width = w_width - 2
    out = make_window(idt-2,str-1,w_width,4,"WHITE","red","yellow","Confirm")
    out << w_update_cursor(idt+1,str+1)
    out << fg("WHITE") << bg("red")
    out << question << "(Y,n): "
  end
end
