require_relative '../lib/bitmap_editor'

RSpec.describe ".color_pixel" do 
   let(:command) { "" }
   let(:columns) {6}
   let(:rows) {5}
   let(:pixel_row) {2}
   let(:pixel_column) {2}
   let(:pixel_color) {"K"}
   let(:err_msg) {"Color should be a capital letter, Row/Column number should be an integer in the range 1 - COL:#{columns}/ROW:#{rows}"}

   def expected_array
      a = Array.new(rows) { Array.new(columns,'O') }
      a[pixel_row-1][pixel_column-1] = pixel_color
      a
   end

   def send_command(command)
     @bitmap.send :color_pixel, command
   end

   context 'when coloring a pixel with a certain color with the command L' do

	   before(:each) do
	  	  @bitmap = BitmapEditor.new
        command = "I #{columns} #{rows}"
        @bitmap.send :initialise_bitmap, command      
	   end

      after(:each) do
         pixel_row = 2
         pixel_column = 2
         pixel_color = "K" 
      end

      it 'it should set only that pixel to the required color', command_l_positive: true do  
         command = "#{pixel_row} #{pixel_column} #{pixel_color}"
         @bitmap.send :color_pixel, command
         expect(@bitmap.bitmap).to eql(expected_array)
      end 

      it 'it should not accept x value > 250', command_l_negative: true do  
         pixel_row = 251
         command = "#{pixel_row} #{pixel_column} #{pixel_color}"
         expect {
           send_command(command)
         }.to raise_error(SystemExit).and output(/#{err_msg}/).to_stdout     
      end 

      it 'it should not accept y value > 250', command_l_negative: true do  
         pixel_column = 280
         command = "#{pixel_row} #{pixel_column} #{pixel_color}"
         expect {
           send_command(command)
         }.to raise_error(SystemExit).and output(/#{err_msg}/).to_stdout     
      end 

      it 'it should not accept x value < 1', command_l_negative: true do  
         pixel_row = 0
         command = "#{pixel_row} #{pixel_column} #{pixel_color}"
         expect {
           send_command(command)
         }.to raise_error(SystemExit).and output(/#{err_msg}/).to_stdout     
      end 

      it 'it should not accept invalid color value', command_l_negative: true do  
         pixel_color = "d"
         command = "#{pixel_row} #{pixel_column} #{pixel_color}"
         expect {
           send_command(command)
         }.to raise_error(SystemExit).and output(/#{err_msg}/).to_stdout     
      end

      it 'it should not accept the command with float value for x', command_l_negative: true do 
         pixel_row = 2.5
         command = "#{pixel_row} #{pixel_column} #{pixel_color}"
         expect {
           send_command(command)
         }.to raise_error(SystemExit).and output(/#{err_msg}/).to_stdout            
      end

      it 'it should not accept the command with float value for y', command_l_negative: true do 
         pixel_column = 4.2
         command = "#{pixel_row} #{pixel_column} #{pixel_color}"
         expect {
           send_command(command)
         }.to raise_error(SystemExit).and output(/#{err_msg}/).to_stdout            
      end

      it 'it should not accept the command with alphanumeric value for x', command_l_negative: true do 
         pixel_row = "A56"
         command = "#{pixel_row} #{pixel_column} #{pixel_color}"
         expect {
           send_command(command)
         }.to raise_error(SystemExit).and output(/#{err_msg}/).to_stdout   
      end
   end
end