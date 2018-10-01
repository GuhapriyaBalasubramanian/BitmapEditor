require_relative '../lib/bitmap_editor'

RSpec.describe ".initialise_bitmap" do 
   let(:columns) {4}
   let(:rows) {5}
   let(:err_msg) {"Row\/column should be an integer in the range 1 - 250"}
   let(:command) { "I #{columns} #{rows}" }

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

      it 'it should accept valid row and column value between 1 and 250', command_i_positive: true do 
         rows = 5
         columns = 4
         command = "I #{columns} #{rows}"
         @bitmap.send :initialise_bitmap, command
         expect(@bitmap.bitmap_cols).to eq columns
         expect(@bitmap.bitmap_rows).to eq rows
         expect(@bitmap.bitmap).not_to be_nil
      end 

      it 'it should not accept row value > 250', command_i_negative: true do 
         rows = 251
         columns = 4
         command = "I #{columns} #{rows}" 
         expect {
		     send_command(command)
		   }.to raise_error(SystemExit).and output(/#{err_msg}/).to_stdout  
         verify_bitmap_nil      
      end

      it 'it should not accept column value > 250', command_i_negative: true do 
         rows = 2
         columns = 251
         command = "I #{columns} #{rows}"  
         expect {
		     send_command(command)
		   }.to raise_error(SystemExit).and output(/#{err_msg}/).to_stdout         
         verify_bitmap_nil  
      end

      it 'it should not accept the command without row value', command_i_negative: true do 
         columns = 100
         command = "I #{columns}" 
         expect {
           send_command(command)
         }.to raise_error(SystemExit).and output(/Please provide the number of rows and columns for the bitmap/).to_stdout         
         verify_bitmap_nil    
      end

      it 'it should not accept the command without row and column value', command_i_negative: true do 
         command = "I" 
         expect {
           send_command(command)
         }.to raise_error(SystemExit).and output(/Please provide the number of rows and columns for the bitmap/).to_stdout         
         verify_bitmap_nil 
      end

      it 'it should not accept the command with float value for row', command_i_negative: true do 
         columns = 2
         rows = 3.1
         command = "I #{columns} #{rows}"
         expect {
           send_command(command)
         }.to raise_error(SystemExit).and output(/#{err_msg}/).to_stdout         
         verify_bitmap_nil   
      end

      it 'it should not accept the command with float value for column', command_i_negative: true do 
         columns = 2.0
         rows = 3
         command = "I #{columns} #{rows}"
         expect {
           send_command(command)
         }.to raise_error(SystemExit).and output(/#{err_msg}/).to_stdout         
         verify_bitmap_nil    
      end

      it 'it should not accept the command with value 0 for column', command_i_negative: true do 
         columns = 0
         rows = 3
         command = "I #{columns} #{rows}" 
         expect {
           send_command(command)
         }.to raise_error(SystemExit).and output(/#{err_msg}/).to_stdout         
         verify_bitmap_nil     
      end

      it 'it should not accept the command with alphanumeric value for row', command_i_negative: true do 
         columns = 2
         rows = "C5"
         command = "I #{columns} #{rows}"
         expect {
           send_command(command)
         }.to raise_error(SystemExit).and output(/#{err_msg}/).to_stdout         
         verify_bitmap_nil     
      end

   end 
end