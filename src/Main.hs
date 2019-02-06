{-# LANGUAGE OverloadedLabels
           , OverloadedStrings 
#-}

module Main where

import Control.Concurrent.Async
import qualified Data.Text as T

import Data.GI.Base
import qualified GI.GLib as GLib
import qualified GI.Gio as Gio
import qualified GI.Gtk as Gtk

main :: IO ()
main = do
    app <- new Gtk.Application [#applicationId := "for.repl"]
    on app #activate $ activateApp app
    Gio.applicationRun app Nothing
    return ()

activateApp :: Gtk.Application -> IO ()
activateApp app = do
    w <- new Gtk.ApplicationWindow [ #title := "Async counting trial"
                                   , #application := app
                                   ]
    e <- new Gtk.Entry [ #parent := w
                       , #progressPulseStep := 0.1
                       , #editable := False
                       ]

    -- a <- asyncBound lenghtyCount
    a <- async lenghtyCount
    GLib.timeoutAdd GLib.PRIORITY_DEFAULT 300 (timeoutFunc e a)

    #showAll w

timeoutFunc :: Gtk.Entry -> Async Int -> GLib.SourceFunc
timeoutFunc e a = do
    r <- poll a
    case r of
        Nothing -> do
            #progressPulse e
            return True
        Just x ->
            case x of
                Left _ -> return False -- should show an error indicator here
                Right x' -> do
                    set e [ #text := T.pack (show x')
                          , #progressPulseStep := 0.0
                          ]
                    return False

lenghtyCount :: IO Int
lenghtyCount = return $ length [0..10000000000]
