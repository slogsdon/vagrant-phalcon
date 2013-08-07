PHP QA Tools
=============

PHP QA Tools enables provisioning most of the quality tools for PHP using Puppet. Refer to http://phpqatools.org for more information.

Dependencies
------------

- Ruby (tested against 1.8 version)
- Rubygems
- Puppet (>= 2.6)

Tools
-----

Currently, the PHP QA Tools project is provisioning the following tools:

* PHP_PMD
* PDepend
* PHPCPD
* Phing
* PHPUnit
* PHPLOC
* PHPDCD
* PHP_CodeSniffer
* Bytekit

Installation
------------

From the command line:

    $ puppet-module install rafaelfc/phpqatools

It will download and install the latest release from the official Puppet Modules Repository, under the `phpqatools` directory.
Watch for the dependency listed in the Modulefile (`rafaelfc/pear`), in case you run into `can't find class pear` errors.


Usage
-----

Inside of a puppet manifest file (let's call it init.pp):

    include phpqatools

Then:

    $ puppet apply init.pp

Known issues
------------

These manifest script were written to cover only CentOS 5.7 and other Redhat-based distros (it's only tested against CentOS 5.7). I would really appreciate some help to make then become more platform-indepent.

Contributing
------------


Want to contribute?

* Fork me on github!
* Pull requests are very welcome!
* Submit any issue you might eventually find
