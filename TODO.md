TO DO list for LeanCheck
========================

List of things to do for LeanCheck.


misc
----

* improve `mk/haskell.mk`: pass ALLHS and LIBHS instead of HSS
  By making that distinction, haskell.mk will be able to handle Haddock.
  It will also be clearer what each parameter means.
  Note that ALLHS and LIBHS are not (but could be) the final names.

* parameterize number of tests in test programs and add slow-test target

* add diff test for IO functions (diff w/ model output and exit status)

* (?) on leancheck.cabal, add upper bound for template-haskell package


documentation
-------------

* add eg folder with some examples of testing using LeanCheck;

* on tutorial.md, write about how to create test programs;

* on data-invariant.md, write missing section;


v0.6.1
------

* implement stub `Test.LeanCheck.Function.*` modules;
