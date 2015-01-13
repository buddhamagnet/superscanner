### TO RUN

* I used rvm. The .ruby-gemset and ruby-version files included here ask for Ruby 2.2.0-p0 and
  a gemset called superscanner. Once that has been set up, run bundle to get the required gems.
* Run ruby superscanner_test.rb and confirm all tests pass.

### NOTES

* This test has been completed using Plain Old Ruby Objects to demonstrate the
algorithm and prove I can program in Ruby, not just Rails!
* The Timecop gem was used in the tests to travel through time and test pricing rule 
  start and expiry times.
* I like explicit returns in Ruby methods.
* The Comparable module is used for price comparisons on the product and rule objects.
* The Forwardable module is used to delegate method calls to composite objects.
