class String
  def decrement!
    self.to_i-1
  end
end


class BitmapEditor
  #It is assumed that the command 'I' will appear only at the start of the input file.
  #The program will report error and continue, if the command 'I' appears anywhere else in the input file.
  #It is also set that the maximum bitmap size is 250 rows and columns.
  attr_accessor :bitmap, :file, :bitmap_rows, :bitmap_cols
  
  def run(file)
    self.file = file
    check_file
    create_bitmap
  end

  private 
    # CONSTANTS
    BITMAP_MAX_SIZE=250
    COMMAND_ERROR_MSG = "Color should be a capital letter, Row/Column number should be an integer in the range 1 -"
    
    #METHODS
    #Check if the file exists
    def check_file
      die("Kindly provide the correct input file") if (file.nil? || !File.exists?(file))
    end

    def create_bitmap
      File.open(file).each_with_index do |line,index|
        line = line.chomp
        if (index == 0) 
          initialise_bitmap(line)     
        else
          process_commands(line)
        end       
      end       
    end

    def initialise_bitmap(line)   
      command,no_cols,no_rows=line.split(" ")
      if (command.eql?"I")
        #Check that there is a non-zero value for rows and columns
        die("Please provide the number of rows and columns for the bitmap") if (no_rows.nil?  || no_cols.nil?)
        error_msg = "Command: #{line}: Row/column should be an integer in the range 1 - #{BITMAP_MAX_SIZE}"
        die(error_msg) unless check_number_validity(no_cols)
        die(error_msg) unless check_number_validity(no_rows)
        #Initialise the bitmap
        self.bitmap_cols = no_cols.to_i
        self.bitmap_rows = no_rows.to_i
        self.bitmap = Array.new(self.bitmap_rows) { Array.new(self.bitmap_cols,'O') }        
      else
        die("Please initialise the bitmap first as I X Y, where X is the number of columns and Y is the number of rows")      
      end
    end

    def process_commands(line)
      command,arguments=line.split(" ",2)
      case command
      when 'S'
        print_bitmap
      when 'C'
        clear_bitmap
      when 'L'
        color_pixel(arguments)
      when 'H'
        draw_horizontal_line(arguments)
      when 'V'
        draw_vertical_line(arguments)
      else
        puts 'Unrecognised command : Allowed commands are S, C, L, V, H'
      end

    end

    #Always verify that x1 <= x2
    #If x1|x2 > max_cols, bail out
    #If y > max_rows, bail out
    def draw_horizontal_line(arguments)
      x1,x2,y,color=arguments.split(" ")
      die("Command: H #{arguments}: #{COMMAND_ERROR_MSG} COL:#{self.bitmap_cols}/ROW:#{self.bitmap_rows}") unless arguments_valid?(color,[x1,x2],[y])
      die("Command: H #{arguments}: x1 should be <= x2") if (x1>x2)
      x1 = x1.decrement!
      x2 = x2.decrement!
      y = y.decrement!
      self.bitmap[y].fill(color,x1..x2)
    end

    #Always verify that y1 <= y2
    #If x > max_cols, bail out
    #If y1|y2 > max_rows, bail out
    def draw_vertical_line(arguments)
      x,y1,y2,color=arguments.split(" ")
      die("Command: V #{arguments}: #{COMMAND_ERROR_MSG} COL:#{self.bitmap_cols}/ROW:#{self.bitmap_rows}") unless arguments_valid?(color,[x],[y1,y2])
      die("Command: V #{arguments}: y1 should be <= y2") if (y1>y2)
      x = x.decrement!
      y1 = y1.decrement!
      y2 = y2.decrement!
      self.bitmap[y1..y2].map! {|a| a[x] = color}
    end

    #If x > max_cols, bail out
    #If y > max_rows, bail out
    def color_pixel(arguments)
      x,y,color=arguments.split(" ")
      die("Command: L #{arguments}: #{COMMAND_ERROR_MSG} COL:#{self.bitmap_cols}/ROW:#{self.bitmap_rows}") unless arguments_valid?(color,[x],[y])
      x = x.decrement!
      y = y.decrement!
      self.bitmap[y][x] = color
    end

    #Prints the bitmap onto STD OUT
    def print_bitmap
      w = bitmap.flatten.max.to_s.size+2
      puts bitmap.map { |a| a.map { |i| i.to_s.rjust(w) }.join }
    end
     
    #Sets all values to O
    def clear_bitmap
      self.bitmap.map! {|a| a.map! { |i| i='O' } }
    end

    ##### HELPERS #######
    def die(error_msg)
      puts "ERROR: #{error_msg}"
      exit
    end

    def arguments_valid?(color,x,y)
      return false unless color_valid?(color)
      x.each {|i| return false if !(is_integer?(i) && check_column?(i))}
      y.each {|i| return false if !(is_integer?(i) && check_row?(i))}   
    end

    def color_valid?(color)
      /^[[:upper:]]$/.match(color) ? true : false
    end

    def check_column?(num)
      (num.to_i.between?(1,self.bitmap_cols)) ? true : false
    end

    def check_row?(num)
      (num.to_i.between?(1,self.bitmap_rows)) ? true : false
    end

    def check_number_validity(number)
      (is_integer?(number) && check_range?(number)) ? true : false
    end

    def check_range?(number)
      (number.to_i.between?(1,BITMAP_MAX_SIZE)) ? true : false
    end

    def is_integer?(number)
      (number.scan(/\D/).empty?) ? true : false
    end 
  
end
