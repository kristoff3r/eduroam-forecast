{-# LANGUAGE OverloadedStrings #-}
module Main where

import qualified Data.ByteString as BS
import 		 Data.Time
import           Control.Applicative
import 		 Control.Monad.IO.Class
import           Snap.Core
import           Snap.Util.FileServe
import           Snap.Http.Server

main :: IO ()
main = quickHttpServe site

site :: Snap ()
site =
    ifTop $ (writeBS $ BS.pack $ getStats) <|>
    route [ ("poke", putStats)
          ] <|>
    dir "static" (serveDirectory ".")

getStats :: Snap (String)
getStats = return $ liftIO $ readFile "stats"

putStats :: Snap ()
putStats = 
  do let time = liftIO getCurrentTime
     liftIO $ appendFile "stats" $ show time
