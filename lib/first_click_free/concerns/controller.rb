require 'active_support/concern'

module FirstClickFree
  module Concerns
    module Controller
      extend ActiveSupport::Concern
      include FirstClickFree::Helpers::Google
      include FirstClickFree::Helpers::Path
      include FirstClickFree::Helpers::Referrer

      module ClassMethods

        # Public: Turn 'on' first click free for this controller.
        #
        # options - The options to pass through to `before_filter`.
        #           Common options are `only` and `except`, to limit
        #           which actions are affected.
        #
        #  DEPRECATION: `before_filter` is deprecated in favour of `before_action`
        #               in Rails 4.
        #
        # Returns the result of the call to `before_filter`.
        def allow_first_click_free(options = {})
          before_filter :record_or_reject_first_click_free!, options
        end

        # Public: Skip first click free for a controller or action.
        #
        # options - The options to pass through to `skip_before_filter`,
        #           for example to limit which actions should be skipped.
        #
        # DEPRECATION: `skip_before_filter` is deprecated in favour of
        #              with `skip_before_action` in Rails 4.
        #
        # Returns the result of the call to `skip_before_filter`.
        def skip_first_click_free(options = {})
          skip_before_filter :record_or_reject_first_click_free!, options
        end

      end

      # Public: Return the user to use when bypassing first click free
      # (i.e. there is a user signed in at the time).
      #
      # This method is intended to be overridden in the controller
      # with the appropriate method call (e.g. current_user).
      #
      # Returns nil, which will cause first click free to always be active.
      def user_for_first_click_free
        nil
      end

      # allow or deny the request for content access.
      def allow_first_click_free?
        @first_click_free
      end

      # Public: Either record a first click free request, or reject
      # the request for a subsequent content access.
      #
      # Raises FirstClickFree::Exceptions::SubsequentAccessException if
      # a first click has already been recorded for this user.
      #
      # Returns true if the referrer User agent is GoogleBot, or
      # if this is the first click recorded for this session.
      def record_or_reject_first_click_free!
        @first_click_free = true

        # Always allow requests from Googlebot
        return true if googlebot?

        # Always allow requests from authenticated users
        return true if user_for_first_click_free

        # Always allow requests to particular paths
        return true if permitted_path?

        # Reset first click free if the domain is permitted
        # (new first click free will be set)
        reset_first_click_free! if permitted_domain?

        if session[:first_click] && session[:first_click].include?(checksum(url_for))
          # already visited, can visit again
        elsif session[:first_click] && session[:first_click].length < FirstClickFree.free_clicks
          # new page but within free click limit
          session[:first_click] << checksum(url_for)
        elsif session[:first_click] && session[:first_click].length == FirstClickFree.free_clicks
          raise FirstClickFree::Exceptions::SubsequentAccessException
        else
          # first click!
          session[:first_click] = [ checksum(url_for) ]
        end
        request.env["first_click_free_count"] = session[:first_click].length
        return true
      rescue FirstClickFree::Exceptions::SubsequentAccessException => e
        @first_click_free = false
        raise FirstClickFree::Exceptions::SubsequentAccessException if FirstClickFree.raise_excaption?
      end

      private

      # Private: Reset first click free session.
      #
      # Returns the value set in the first click session (nil)
      def reset_first_click_free!
        session.delete(:first_click)
      end

      # Private: Create a checksum string.
      #
      # Returns a checksum of the url as a string
      def checksum(url)
        Zlib.adler32(url).to_s
      end
    end
  end
end
