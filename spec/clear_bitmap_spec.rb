require_relative '../lib/bitmap_editor'

RSpec.describe ".clear_bitmap" do 
   let(:command) { "" }
   let(:columns) {5}
   let(:rows) {5}

   def expected_array
      Array.new(rows) { Array.new(columns,'O') } 
   end

   def color_coord
      command = "1 1 A"
      @bitmap.send :color_pixel, command
      expect(@bitmap.bitmap[0][0]).to eql("A")
   end

   context 'when clearing the bitmap with the command C' do

	   before(:each) do
	  	  @bitmap = BitmapEditor.new
        command = "I #{columns} #{rows}"
        @bitmap.send :initialise_bitmap, command      
	   end

      it 'it should clear the bitmap with all rows and columns set to O', command_c_positive: true do  
         color_coord
         @bitmap.send :clear_bitmap
         expect(@bitmap.bitmap).to eql(expected_array)
      end 
   end
end