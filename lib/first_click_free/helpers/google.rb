module FirstClickFree
  module Helpers
    module Google

      # Public: Determine whether the agent requesting the resource
      # is a Googlebot.
      #
      # This method operates by examining the User agent of the request.
      # If the appropriate configuration is activated, it will also
      # perform the necessary DNS requests to verify that the request
      # originates from Google.
      #
      # perform_dns_lookup -  Perform a DNS lookup to verify that the request
      #                       is originating from Google.
      #
      # Returns true if a Googlebot has been identified, false if not.
      def googlebot?(use_dns_lookup = true)
        user_agent = request.user_agent || ""
        (FirstClickFree.test_mode && params.key?(:googlebot)) ||\
        (user_agent.include?("Googlebot") && (use_dns_lookup ? verify_googlebot_domain : true))
      end

      private

      # Private: Perform a reverse and then forward DNS lookup to
      # verify that this request is coming from the correct domain
      # (googlebot.com).
      #
      # Returns true if the hostname ends with googlebot.com and the
      # forward DNS lookup IP address matches the request's remote IP address.
      def verify_googlebot_domain
        hostname = Resolv.getname(request.remote_ip)
        # Structure of lookup return is:
        # ["AF_INET", 80, "66.249.66.1", "66.249.66.1", 2, 2, 17]
        ip       = Socket.getaddrinfo(hostname, "http").first[2]

        hostname =~ /.googlebot.com\Z/ && ip == request.remote_ip
      end

    end
  end
end
