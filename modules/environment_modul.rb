# environment_modul.rb

module Bejana
  module EnvironmentModul
    class Environment
      def initialize
        @storage = {}
      end

      def set(kunci, nilai)
        @storage[kunci.to_sym] = nilai
      end

      def get(kunci)
        @storage[kunci.to_sym]
      end

      def exist?(kunci)
        @storage.key?(kunci.to_sym)
      end

      def all
        @storage
      end

      def delete(kunci)
        @storage.delete(kunci.to_sym)
      end

      def clear
        @storage.clear
      end
    end
  end
end