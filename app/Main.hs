module Main where

import           BeholderObserver.Dispatch
import           BeholderObserver.AcidState
import           BeholderObserver.Data
import qualified Web.Scotty as S

main :: IO ()
main = do
  dl <- load :: IO AcidStateDataLoader
  S.scotty 8080 $ site dl
