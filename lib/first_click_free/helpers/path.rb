module FirstClickFree
  module Helpers
    module Path

      require 'uri'

      # Public: Determine if the requested path is allowed to bypass
      # first click free.
      #
      # This method will check if the requested path is in a list of
      # specifically known paths (see FirstClickFree.permitted_paths). By
      # default the permitted paths list is empty so no special paths are
      # allowed.
      #
      # Returns true if the requested path is specifically permitted, or
      # false if it is not.
      def permitted_path?
        FirstClickFree.permitted_paths.include?(URI.parse(request.fullpath).path)
      end
    end
  end
end