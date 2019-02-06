# gi-async-trial

This is a trial for using Control.Concurrent.Async.Async in a haskell-gi program.

On Windows 10, a lengthy concurrent process locks the UI when using LTS-12.26. 

I tried to test it on the last LTS (13.6) but failed to compile gi-cairo and gi-pango even though I applied all suggestions.