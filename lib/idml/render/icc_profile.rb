# frozen_string_literal: true

module Idml
  module Render
    # Locates an sRGB ICC profile for PDF/A output intent embedding.
    # The idml gem does not bundle a binary ICC asset; instead, this
    # helper probes a small set of well-known locations in priority
    # order and returns the first match as raw bytes.
    #
    # Priority:
    #   1. `ENV["IDML_SRGB_ICC"]` — explicit user override.
    #   2. `data/idml/srgb.icc` inside the gem tree (user-vendored).
    #   3. macOS system profile at
    #      `/System/Library/ColorSync/Profiles/sRGB Profile.icc`.
    #
    # Returns `nil` when no profile is available — callers (Pipeline)
    # should skip ICC embedding in that case rather than raising.
    module IccProfile
      GEM_DATA_PATH = File.expand_path("../../../data/idml/srgb.icc", __dir__)
      MACOS_SYSTEM_PATH = "/System/Library/ColorSync/Profiles/sRGB Profile.icc"

      def self.srgb_bytes
        candidate_paths.each do |path|
          bytes = read_if_present(path)
          return bytes if bytes
        end
        nil
      end

      def self.candidate_paths
        [
          ENV.fetch("IDML_SRGB_ICC", nil),
          GEM_DATA_PATH,
          MACOS_SYSTEM_PATH,
        ].compact
      end
      private_class_method :candidate_paths

      def self.read_if_present(path)
        return nil unless path && !path.empty?
        return nil unless File.exist?(path)

        File.binread(path)
      rescue StandardError
        nil
      end
      private_class_method :read_if_present
    end
  end
end
