CIAU CIAU - Configuration and Installation AUtomation
=====================================================

Ciauciau is a simple set of script to automate installations of www.katello.org

What the?!

It's a very trivial "framework" written in Bash and you can leverage it
for installation of various software projects. It has simple concept of 
steps and plans, so you can schedule installations and configurations
in a simple and reusable way.

Upstream site is at http://github.com/lzap/ciauciau

Best to use with http://github.com/lzap/snap-guest

Features
--------

 * installs and configures katello
 * highly flexible

Requirements
------------

 * bash :-)
 * coreutils
 * vim (no, you don't really need it, but it's recommended :-)

Installation
------------

 * git clone git://github.com/lzap/ciauciau.git
 * echo 'PATH=$PATH:ciauciau/bin' >> ~/.bashrc
 * source ~/.bashrc

How it works
------------

    OPTIONS:
      -h    Show this message
      -p    Plan name (see ./plans directory)
      -e    Evaluate statement before plan file (see plan file for options)
      -x    Exclude one or more steps from the plan (grep syntax)
      -i    Include extra steps to the plan (separate by space)

    EXAMPLES:

      ciau -p nightly
      ciau -p nightly -x '(300|301)' -i 200-my-step.sh
      ciau -p nightly -e 'MIRROR=http://abc/nightly EPEL=http://xyz/pup/epel'

Example scripts - Katello
-------------------------

To install Katello systems management cloud solution (www.katello.org) just do 
this:

    ciau -p nightly

If you need to change repositories (e.g. you have closer mirror for Katello and 
EPEL repos) setup those variables (see plans/nightly for more info):

    export MIRROR=http://my.mirror.com/koji
    export EPEL=http://my.epel.mirror.com/pub/fedora/epel
    ciau -p nightly

To see all available plans open the ./plans directory:

https://github.com/lzap/ciauciau/tree/master/plans

And to see particular steps (so you can skip them or create your own plans) 
see:

https://github.com/lzap/ciauciau/tree/master/steps

Easy, huh?

Why the name
------------

Because I can!

![ciau ciau](http://images04.olx.lt/ui/2/97/15/25499215_1.jpg "Ciau Ciau")

Credits and license
-------------------

Ciau Ciau and all the scripts are distributed as public domain.

vim: tw=79:fo+=w
