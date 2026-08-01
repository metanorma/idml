# frozen_string_literal: true

module Idml
  module Composition
    # Prefix every `Self` attribute value across every part of a package
    # so it can be safely composed with another package without ID
    # collisions. This is the foundation operation — every other
    # composition op (InsertIdml, AddPageFromIdml) prefixes the source
    # package first.
    #
    # Returns a new Package; the receiver is unchanged. Round-trips
    # through Package#each_part + Package.write — does not require typed
    # models to be complete.
    class Prefix
      def initialize(package)
        @package = package
      end

      def call(prefix:)
        parts = @package.each_part.to_a.to_h do |name, xml|
          [name, prefix_self_ids(name, xml, prefix)]
        end
        Package.write(parts: parts, to: tmp_path)
      end

      private

      def prefix_self_ids(name, xml, prefix)
        return xml if name == "mimetype"

        xml.gsub(/Self="([^"]+)"/) do
          %(Self="#{prefix}#{Regexp.last_match(1)}")
        end
      end

      def tmp_path
        @tmp_path ||= File.join(Dir.mktmpdir, "prefixed.idml")
      end
    end
  end
end
