module Main where

import           BeholderObserver.Dispatch
import           BeholderObserver.Constant
import qualified Web.Scotty as S

main :: IO ()
main = S.scotty 8080 $ site ConstantDataLoader
