require_relative '../lib/bitmap_editor'

RSpec.describe ".check_file" do 

   let(:err_msg) {"Kindly provide the correct input file"}

   def incorrect_file
      "examples/unknown.txt"
   end

   def valid_file
      "examples/show.txt"
   end

   def send_command
     @bitmap.send :check_file
   end

   context 'when accessing the input file' do

	   before(:each) do
	  	  @bitmap = BitmapEditor.new         
	   end

      it 'it should not print error if file is present', check_file_positive: true do  
         @bitmap.file = valid_file
         expect {
           send_command
         }.to output("").to_stdout 
      end 

      it 'it should exit and print error if file not present', check_file_negative: true do  
         @bitmap.file = incorrect_file
         expect {
           send_command
         }.to raise_error(SystemExit).and output(/#{err_msg}/).to_stdout 
      end 

      it 'it should exit and print error if file is nil', check_file_negative: true do  
         @bitmap.file = nil
         expect {
           send_command
         }.to raise_error(SystemExit).and output(/#{err_msg}/).to_stdout 
      end 
   end
end