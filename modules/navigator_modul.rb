# modules/navigator_modul.rb

module Bejana
  module NavigatorModul
    class Navigator
      def initialize(content = nil)
        @langkah = {}
        @current = nil
        @context = content
      end

      def tambah(nama, &blok)
        @langkah[nama.to_sym] = blok;
       end

      def mulai_dari(nama)
        @current = nama.to_sym
        while @current && @langkah[@current]
          @current = @context.instance_eval(&@langkah[@current])
        end
      end
    end
  end
end
