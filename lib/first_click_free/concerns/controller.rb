require 'active_support/concern'

module FirstClickFree
  module Concerns
    module Controller
      extend ActiveSupport::Concern
      include FirstClickFree::Helpers::Google

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


      # Public: Either record a first click free request, or reject
      # the request for a subsequent content access.
      #
      # Raises FirstClickFree::Exceptions::SubsequentAccessException if
      # a first click has already been recorded for this user.
      #
      # Returns true if the referrer User agent is GoogleBot, or
      # if this is the first click recorded for this session.
      def record_or_reject_first_click_free!
        # Always allow requests from Googlebot
        return true if googlebot?

        # Has this session already visited?
        if session[:first_click]
          raise FirstClickFree::Exceptions::SubsequentAccessException
        else
          session[:first_click] = Time.zone.now
          return true
        end
      end

    end
  end
end