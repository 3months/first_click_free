First Click Free
===

[![Build Status](https://travis-ci.org/3months/first_click_free.svg)](https://travis-ci.org/3months/first_click_free)

[First Click Free](https://support.google.com/webmasters/answer/74536?hl=en) is one of three methods recommended officially by Google for improving search rankings for subscription, paywall and other restricted access sites.

The technique involves making available the first n 'clicks', or pageviews for each user, and giving Google's crawling bots full access to index site content. This way, users coming from social media sites and search results are able to 'preview' the content they have been looking for, and search engines are able to fully index a site, even though it would normally require registration and/or payment.

This gem aims to simplify and centralize the process of adding first click free support to a Rails application. It's fully tested, and used in production by our clients at [3months.com](https://3months.com).

Use
---

**Rails is required to use this gem**

1. Install: Add `gem 'first_click_free'` to your `Gemfile` and run `bundle install`
2. For any controller that should have first click free activated, call `allow_first_click_free` in your controller definition, for example:

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

Optional use
---

1. You may also permit certain individual paths to bypass first click free by setting them in an initializer like so
`FirstClickFree.permitted_paths = [ '/about', '/contact' ]`. These paths do not set or reset the users' first click free status.
2. By default users will get just 1 free click, however by setting `FirstClickFree.free_clicks` in an initializer you can allow n free clicks to content.
3. A count of users' free clicks are available in request.env["first_click_free_count"].

4. throw exception option. `FirstClickFree.raise_exception` in an initializer.

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
* If that same user attempts to access any other URL marked as first click free, an exception is raised so that the application can redirect or display a message to that user.

##### For visitors coming from a Google, Bing, or Yahoo search

* When a user's HTTP referrer matches a list of known search engine domains, the request is allowed to override any previously set first click free.
* It does not disable first click free, it just modifies which page that user may access.
* For example, if a user searches for a page on your site using Google, and clicks on the first result, that page will be marked as first click free for them - any subsequent clicks from that page will trigger the first click free error. If they go back to the search results though, and then click on the second result, that page will take the place of the first and they will be able to access that page as normal.


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
* Push up your branch to Github, and create a pull request. Please don't change the gem version or anything, we will do that bit.


License
---

This project rocks and uses MIT-LICENSE.
