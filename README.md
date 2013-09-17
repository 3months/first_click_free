First Click Free
===

[First Click Free](https://support.google.com/webmasters/answer/74536?hl=en) is one of three methods recommended officially by Google for improving search rankings for subscription, paywall and other restricted access sites.

The technique involves making available the first 'click', or pageview for each user, and giving Google's crawling bots full access to index site content. This way, users coming from social media sites and search results are able to 'preview' the content they have been looking for, and search engines are able to fully index a site, even though it would normally require registration and/or payment.

This gem aims to simplify and centralize the process of adding first click free support to a Rails application. It's fully tested, and used in production with many of our clients at [3months.com](https://3months.com).

Use
---

**Rails is required to use this gem**

1. Install: Add `gem 'first_click_free'` to your `Gemfile` and run `bundle install`
2. For any controller that should have first click free activated, simply call `allow_first_click_free` in your controller definition, for example:
   ``` ruby
   class PagesController
     allow_first_click_free
   end
   ```
   You may pass through `only`, or `except` to restrict which actions will have first click free turned on, or you can put this in your `ApplicationController` to turn on first click free for all controllers.
3. Handle the exception that is raised when a user tries to visit more than one page without being signed in:
	``` ruby
	rescue_from FirstClickFree::Exceptions::SubsequentAccessException do
	  redirect_to root_path, alert: 'Please sign in to continue.'
	end
	```
4. Good to go!

#### Registered Users

If you have registered users that should always be allowed through (they shouldn't be affected by any first click free rules), then you can override the `user_for_first_click_free` method in `ApplicationController`, or any of your controllers using `allow_first_click_free`. This method should return either a falsy value if no-one is signed in, or the current user.

Example:

``` ruby
  class ApplicationController
    # …snip
  
    protected
  
    def user_for_first_click_free
      current_member
    end
  end
```



How it works
---

##### For visitors

* When a user first lands in a controller marked as being first click free, a session variable is set.
* If that same user attempts to access any other controller, or the same controller, marked as first click free, an exception is raised so that the application can redirect or display a message to that user.

##### For Google's indexing services

* If the requesting agent is recognized as a 'Googlebot', the request is allowed though as if they were a registered user, so that the content may be indexed.
* Googlebot recognition is based on two factors:
	* User agent: Google's indexers request a page with a user agent string of 'Googlebot' - this is used as the first-level of checking to make sure the page should be displayed. A user-agent string can be spoofed though, so the second check is:
	* DNS: A reverse DNS request is issued against the remote IP, to ensure that the hostname returned matches a 'googlebot.com' domain. A forward DNS request is then issued against the hostname, to ensure that it matches back up with the original IP address.

Contributing
---

* Contributions are welcome! 
* Please fork this repository, and run `bundle install` to install the development dependencies (RSpec and SQLite).
* Create a new git branch to contain your changes. Try and limit commits to this branch to the specific changes you want to be merged in. 
* Push up your branch to Github, and create a pull request. Please don't change the gem version or anything, I can do that bit.
* All pull requests will be reviewed ASAP. If it's not ready for merge, I'll help you to get it to a stage where it is!



License
---

This project rocks and uses MIT-LICENSE.