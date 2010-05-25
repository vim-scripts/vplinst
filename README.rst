=========
 Vplinst
=========


What is Vplinst?
================

Vplinst stands for "VIM plugin installer" and is an attempt to make an
automatic plugin installer for Vim_.

.. _Vim: http://www.vim.org/

It consists in awk and sh scripts, that almost match POSIX and may run in any
UNIX operating system with /bin/sh and awk.


Goals
=====

Provide a simple script (which interpreters on a Unix system base, like sh and
awk) to install automatically a set of plugins, from a configuration file.


How does it work?
=================

There is a configuration file called ``vplinst.conf`` where you specify plugin
information, like its name, url, id, etc.  Check the `Vplinst configuration`_
page section for more information.

Also, there is a awk script called ``download.awk``, which downloads the
plugins and call ``setup.sh``, that installs plugins in your ``~/.vim``
directory, or wherever you specify.

You might not call ``setup.sh`` directly, because it is called from the
``download.awk`` script, after parsing the ``vplinst.conf`` file.  So, to make
Vplinst work call::

    awk -f download.awk extensions.conf

The ``vplinst.sh`` script already does that.


Vplinst configuration
=====================

TODO: yeah, this is lacking. Check out ``vplinst.conf`` for examples.


Similar projects
================

* GetLatestVimScripts_
* `Download Vim Scripts as Cron Task`_
* Vimana_
* vim-addon-manager_

.. _GetLatestVimScripts: http://www.vim.org/scripts/script.php?script_id=642
.. _`Download Vim Scripts as Cron Task`: http://www.vim.org/scripts/script.php?script_id=2444
.. _Vimana: http://search.cpan.org/~cornelius/Vimana-0.04/lib/Vimana.pm
.. _vim-addon-manager: http://github.com/MarcWeber/vim-addon-manager

Why I didn't use any of these projects?  Here I write down the reasons:

* GetLatestVimScripts_ and `Download Vim Scripts as Cron Task`_ get the latest
  version of a script and downloads it, but they do not install it.  Although
  I didn't think about integrating Vplinst with these scripts, that might be a
  fine idea for the future.

* Vimana_ seems to be a great application and a full-featured plugin manager,
  so the reasons that I didn't use it deserve a detailed explanation:

    - It depends of dozen of Perl extensions that I found difficult to install
      with a broken internet connection and are not guaranteed to work on now
      GNU/Linux systems, just because authors don't test their libraries
      there;

    - Also, although Perl is almost ubiquitous, it is not omnipresent as
      ``/bin/sh``;

    - Vimana_ requires that plugins put a comment in the form ``"
      ScriptType: [script type]`` on its body, but not all define that;

    - There seem to be documented features and options, but some doesn't seem
      to work (like the ``--force (-f)`` option.

  There is, though, some good reasons why I should use it:

    - It seem to be a full-featured package manager for Vim plugins;

    - It gets the latest Vim plugins;

    - Very well documented and very mature.

  For these good reasons this is a good project that I can use and hack when I
  have time. When this time comes, Vplinst will be considered obsolete.

* I didn't touch vim-addon-manager_ so much, but I thought it confusing and
  bad documented, so I soon abandoned it.
