{-# LANGUAGE OverloadedStrings #-}
module Main (main) where

import           Test.Hspec
import           Test.Hspec.Wai
import           Test.Hspec.Wai.JSON
import           Data.Aeson (Value(..), object, (.=))
import qualified Web.Scotty as S
import           BeholderObserver.Dispatch
import           BeholderObserver.Constant

main :: IO ()
main = do
  appendFile "test.hi" "Testing writing to FS."
  hspec spec

spec :: Spec
spec = with (S.scottyApp $ site ConstantDataLoader) $ do
  describe "GET /" $ do
    it "has 'Content-Type: text/plain; charset=utf-8'" $ do
      get "/" `shouldRespondWith` 200 {matchHeaders = ["Content-Type" <:> "text/html; charset=utf-8"]}

  describe "GET /test" $ do
    it "responds with 200 / 'hello'" $ do
      get "/test" `shouldRespondWith` "Hello World!" {matchStatus = 200}
