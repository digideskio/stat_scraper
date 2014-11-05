# Stat Scraper

Scrapes statistics from the [Canvas-LMS](https://github.com/instructure/canvas-lms) Course Statistics page for every course specified in the report you use as input.

# Usage

## First Time Use

The first time you use this script, you will need to install required gems using Bundler.

	$ bundle install

Most user accounts are setup to login to Canvas via an authentication method such as SAML, LDAP or CAS. This script uses
a plain-text login supported by Canvas which can be added to the user account that you will be used to authenticate.

This plain-text login is added to your account by searching for your user, viewing the user profile page (/accounts/:account_id/users/:user_id), and then under the 'Login Information' form using the 'Add Login' link to establish a unique login ID and password. The use of an email address is recommended as the 'Login' value for this form.

After you've configured this plain-text username/password, open the config.example.yml file and save it as config.yml. Next edit the 'auth_user' and 'auth_pass' values to reflect the login and password for your Canvas-LMS user account that has Account Admin privileges.

## Providing Courses CSV Report

Generate a Provisioning report from 'Reports' tab of the Settings page for your Canvas-LMS account, with only the 'Courses CSV' option selected. You can choose to create a report for all terms, or only a specific term.

Once this report is generated, place it inside of the 'reports' directory for this tool, and then edit the
config.yml file so that the 'report_filename' value reflects the name of the report file that you've placed in the directory.

## Run the primary script

From the command line simply run the 'main.rb' script.

	$ ./main.rb
