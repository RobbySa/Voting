## Choice explanation

# Data and DB
The data given for this exercise is a file made of multiple line following this structure:
VOTE [int] Campaign:[string] Validity:[string] Choice:[string] CONN:[string] MSISDN:[int] GUID:[id] Shortcode:[int]

for the purpose of this exercise I am only interested in these fields:
VOTE [int] Campaign:[string] Validity:[string] Choice:[string]

When loading the data each vote is checked to see if it followed this standard by using a regular expression, which is also how the data is then extracted.

# Tables
Two tables are set up one for Campaigns with the following fields:
ID (int) | Name (string)

and one for Votes with the following fields:
ID (int) | Epoch (int) | Validity (string) | Choice (string) | Campaign_id (foreign_key)

An alternative way to store validity would have been to store it as a boolean by evaluating it's validity when saving the data
But I felt that leaving it as a string made the set up more flexible in light of possible future changes:
- It is still easy to change it from string to boolean by making a second script
- It is impossible to go back from boolean to string as there were more than 2 possible values for Validity

# Rails Model
The Campaign table is set with a has_many to provide easy access to all the votes which have its foreign key

# Controller
Only 1 controller was implemented, this controlled two possible pages:
- Index page where it is possible to see all the campaigns in the DB
- Show page where the votes that each candidate received during the selected campaign can be seen

# Views
In the show page the list of campaigns is still visible and can be used to switch between different campaigns the same way the index page works.
This was done simply because of aesthetics as both the index and show page looked very empty when showing only 1 table.

Since the code to show the list of campaign is shared between the Index and Show page, a partial is used to extract that code and keep it common

# Gems/Css
The page is styled solely with css, no js was used in order to keep the application simple.
For the same reason no external gem was used outside of the ones that come with a default new rails application.

With very few exception all the css used can be found in app/assets/stylesheets/application.css.

# Lack of testing
Normally I would approach this by writing system tests, followed by unit tests and if necessary view tests.
However I decided against this for a reasons:
- I am used to write tests using a gem called 'Rspec' but I decided to not use any extenal gems for this exercise and I am not familiar with how tests are normally written in plain Rails
