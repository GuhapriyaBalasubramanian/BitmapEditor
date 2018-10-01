require_relative '../lib/bitmap_editor'

RSpec.describe ".draw_horizontal_line" do 
   let(:command) { "" }
   let(:columns) {4}
   let(:rows) {5}
   let(:y) {2}
   let(:x1) {2}
   let(:x2) {4}
   let(:color) {"L"}
   let(:err_msg) {"Color should be a capital letter, Row/Column number should be an integer in the range 1 - COL:#{columns}/ROW:#{rows}"}
   let(:arg_err_msg) {"x1 should be <= x2"}

   def expected_array
      a = Array.new(rows) { Array.new(columns,'O') }
      i1 = x1-1
      i2 = x2-1
      j = y-1
      a[j].fill(color,i1..i2)
      a
   end

   def send_command(command)
     @bitmap.send :draw_horizontal_line, command
   end

   context 'when drawing a horizontal line of a certain color with the command H' do

	   before(:each) do
	  	  @bitmap = BitmapEditor.new
        @bitmap.bitmap = Array.new(rows) { Array.new(columns,'O') } 
        @bitmap.bitmap_cols = columns
        @bitmap.bitmap_rows = rows  
	   end

      after(:each) do
         y=2
         x1=2
         x2=4
         color="L"
      end

      it 'it should draw a horizontal line of that color with the specified co-ordinates', command_h_positive: true do  
         command = "#{x1} #{x2} #{y} #{color}"
         @bitmap.send :draw_horizontal_line, command
         expect(@bitmap.bitmap).to eql(expected_array)
      end 

      it 'it should not accept the command if x1 > x2', command_h_negative: true do  
         x1 = 4
         x2 = 3
         command = "#{x1} #{x2} #{y} #{color}"
         expect {
           send_command(command)
         }.to raise_error(SystemExit).and output(/#{arg_err_msg}/).to_stdout     
      end

      it 'it should not accept the command if x1 > number of columns', command_h_negative: true do  
         x1=5
         command = "#{x1} #{x2} #{y} #{color}"
         expect {
           send_command(command)
         }.to raise_error(SystemExit).and output(/#{err_msg}/).to_stdout     
      end

      it 'it should not accept the command if y > number of rows', command_h_negative: true do  
         y = 6
         command = "#{x1} #{x2} #{y} #{color}"
         expect {
           send_command(command)
         }.to raise_error(SystemExit).and output(/#{err_msg}/).to_stdout     
      end

       it 'it should not accept invalid color value', command_h_negative: true do  
         color = "d2"
         command = "#{x1} #{x2} #{y} #{color}"
         expect {
           send_command(command)
         }.to raise_error(SystemExit).and output(/#{err_msg}/).to_stdout     
      end

      
   end
end