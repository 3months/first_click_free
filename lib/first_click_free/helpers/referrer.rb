module FirstClickFree
  module Helpers
    module Referrer

      # Public: Determine if the request referrer is allowed to bypass
      # first click free.
      #
      # By default, this method will check if the request referrer is in
      # a list of known search engine domains (see config/domains.yml). If
      # the domain is a search engine domain, then the request will bypass
      # any present first click free, as most search engines require
      # that first click free pages always be accessible from search listings.
      #
      # Returns true if the domain from the request referrer is permitted, or
      # false if it is not.
      def permitted_domain?
        request.try(:referrer) && FirstClickFree.permitted_domains.any? do |domain|
          URI.parse(request.referrer).hostname =~ /#{domain}\Z/
        end
      end
    end
  end
end