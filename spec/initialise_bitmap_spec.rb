require_relative '../lib/bitmap_editor'

RSpec.describe "Test Command L: initialise_bitmap" do 
   let(:command) { "I 4 5" }

   def send_command(command)
     @bitmap.send :initialise_bitmap, command
   end

   def verify_bitmap_nil
      expect(@bitmap.bitmap_cols).to be_nil
      expect(@bitmap.bitmap_rows).to be_nil
      expect(@bitmap.bitmap).to be_nil   
   end

   context 'when initialising the bitmap with the I command' do

	   before(:each) do
	  	  @bitmap = BitmapEditor.new
	   end

      it 'the program should accept row and column value between 1 and 250', command_l_positive: true do 
         command = "I 4 5"
         @bitmap.send :initialise_bitmap, command
         expect(@bitmap.bitmap_cols).to eq 4
         expect(@bitmap.bitmap_rows).to eq 5
         expect(@bitmap.bitmap).not_to be_nil
      end 

      it 'the program should not accept row value > 250', command_l_negative: true do 
         command = "I 4 251" 
         expect {
		     send_command(command)
		   }.to raise_error(SystemExit).and output(/Row\/column should be an integer in the range 1 - 250/).to_stdout  
         verify_bitmap_nil      
      end

      it 'the program should not accept column value > 250', command_l_negative: true do 
         command = "I 251 2" 
         expect {
		     send_command(command)
		   }.to raise_error(SystemExit).and output(/Row\/column should be an integer in the range 1 - 250/).to_stdout         
         verify_bitmap_nil  
      end

      it 'the program should not accept the command without row value', command_l_negative: true do 
         command = "I 2" 
         expect {
           send_command(command)
         }.to raise_error(SystemExit).and output(/Please provide the number of rows and columns for the bitmap/).to_stdout         
         verify_bitmap_nil    
      end

      it 'the program should not accept the command without column value', command_l_negative: true do 
         command = "I" 
         expect {
           send_command(command)
         }.to raise_error(SystemExit).and output(/Please provide the number of rows and columns for the bitmap/).to_stdout         
         verify_bitmap_nil 
      end

      it 'the program should not accept the command with float value for row', command_l_negative: true do 
         command = "I 2 3.1" 
         expect {
           send_command(command)
         }.to raise_error(SystemExit).and output(/Row\/column should be an integer in the range 1 - 250/).to_stdout         
         verify_bitmap_nil   
      end

      it 'the program should not accept the command with float value for column', command_l_negative: true do 
         command = "I 2.0 3" 
         expect {
           send_command(command)
         }.to raise_error(SystemExit).and output(/Row\/column should be an integer in the range 1 - 250/).to_stdout         
         verify_bitmap_nil    
      end

      it 'the program should not accept the command with value 0 for column', command_l_negative: true do 
         command = "I 0 3" 
         expect {
           send_command(command)
         }.to raise_error(SystemExit).and output(/Row\/column should be an integer in the range 1 - 250/).to_stdout         
         verify_bitmap_nil     
      end

      it 'the program should not accept the command with alphanumeric value for row', command_l_negative: true do 
         command = "I 2 C5" 
         expect {
           send_command(command)
         }.to raise_error(SystemExit).and output(/Row\/column should be an integer in the range 1 - 250/).to_stdout         
         verify_bitmap_nil     
      end



   end 
end