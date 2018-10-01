require_relative '../lib/bitmap_editor'

RSpec.describe ".draw_vertical_line" do 
   let(:command) { "" }
   let(:columns) {4}
   let(:rows) {5}
   let(:x) {2}
   let(:y1) {3}
   let(:y2) {5}
   let(:color) {"J"}
   let(:err_msg) {"Color should be a capital letter, Row/Column number should be an integer in the range 1 - COL:#{columns}/ROW:#{rows}"}
   let(:arg_err_msg) {"y1 should be <= y2"}

   def expected_array
      a = Array.new(rows) { Array.new(columns,'O') }
      i1 = y1-1
      i2 = y2-1
      j = x-1
      a[i1..i2].map! {|a| a[j] = color}
      a
   end

   def send_command(command)
     @bitmap.send :draw_vertical_line, command
   end

   context 'when drawing a vertical line of a certain color with the command V' do

	   before(:each) do
	  	  @bitmap = BitmapEditor.new
        @bitmap.bitmap = Array.new(rows) { Array.new(columns,'O') } 
        @bitmap.bitmap_cols = columns
        @bitmap.bitmap_rows = rows  
	   end

      after(:each) do
         x=2
         y1=3
         y2=5
         color="J"
      end

      it 'it should draw a vertical line of that color with the specified co-ordinates', command_v_positive: true do  
         command = "#{x} #{y1} #{y2} #{color}"
         @bitmap.send :draw_vertical_line, command
         expect(@bitmap.bitmap).to eql(expected_array)
      end 

      it 'it should not accept the command if y1 > y2', command_v_negative: true do  
         y1 = 5
         y2 = 3
         command = "#{x} #{y1} #{y2} #{color}"
         expect {
           send_command(command)
         }.to raise_error(SystemExit).and output(/#{arg_err_msg}/).to_stdout     
      end

      it 'it should not accept the command if x > number of columns', command_v_negative: true do  
         x=5
         command = "#{x} #{y1} #{y2} #{color}"
         expect {
           send_command(command)
         }.to raise_error(SystemExit).and output(/#{err_msg}/).to_stdout     
      end

      it 'it should not accept the command if y2 > number of rows', command_v_negative: true do  
         y2 = 6
         command = "#{x} #{y1} #{y2} #{color}"
         expect {
           send_command(command)
         }.to raise_error(SystemExit).and output(/#{err_msg}/).to_stdout     
      end

       it 'it should not accept invalid color value', command_v_negative: true do  
         color = "d2"
         command = "#{x} #{y1} #{y2} #{color}"
         expect {
           send_command(command)
         }.to raise_error(SystemExit).and output(/#{err_msg}/).to_stdout     
      end

      
   end
end