require_relative '../lib/bitmap_editor'

RSpec.describe ".print_bitmap" do 
   let(:command) { "" }
   let(:columns) {8}
   let(:rows) {3}
   let(:x) {2}
   let(:y) {2}
   let(:color) {"K"}

   def expected_array
      a = Array.new(rows) { Array.new(columns,'O') }
      w = a.flatten.max.to_s.size+2
      a.map { |a| a.map { |i| i.to_s.rjust(w) }.join }.join("\n")+"\n"
   end

   def colored_bitmap
      a = Array.new(rows) { Array.new(columns,'O') }
      a[x-1][y-1] = color
      w = a.flatten.max.to_s.size+2
      a.map { |a| a.map { |i| i.to_s.rjust(w) }.join }.join("\n")+"\n"
   end

   context 'when printing the bitmap with the command S, after initialisation' do

	   before(:each) do
	  	  @bitmap = BitmapEditor.new
        command = "#{columns} #{rows}"
        @bitmap.send :initialise_bitmap, command      
	   end

      it 'it should print the expected bitmap', command_s_positive: true do  
         expect {
           @bitmap.send :print_bitmap
         }.to output(expected_array).to_stdout   
      end 
   end

   context 'when printing the bitmap with the command S, after changing color' do

      before(:each) do
        @bitmap = BitmapEditor.new
        command = "#{columns} #{rows}"
        @bitmap.send :initialise_bitmap, command
        command = "#{x} #{y} #{color}"
        @bitmap.send :color_pixel, command
      end

      it 'it should print the expected bitmap', command_s_positive: true do  
         expect {
           @bitmap.send :print_bitmap
         }.to output(colored_bitmap).to_stdout   
      end 
   end
end