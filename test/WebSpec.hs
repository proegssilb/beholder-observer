{-# LANGUAGE OverloadedStrings #-}
module WebSpec (spec) where

  import           Test.Hspec
  import           Test.Hspec.Wai
  import           Data.Aeson (Value(..), object, (.=))
  import           Data.Acid
  import           Data.Acid.Memory
  import           Data.Map as M (empty)
  import qualified Web.Scotty as S
  import           BeholderObserver.Dispatch
  import           BeholderObserver.AcidState

  main :: IO ()
  main = hspec spec

  spec :: Spec
  spec = beforeAll (do
      as <- openMemoryState (KeyVal M.empty)
      S.scottyApp $ site as) $
      do
    describe "GET /" $
      it "has 'Content-Type: text/plain; charset=utf-8'" $
        get "/" `shouldRespondWith` 200 {matchHeaders = ["Content-Type" <:>
            "text/html; charset=utf-8"]}

    describe "GET /test" $
      it "responds with 200 / 'hello'" $
        get "/test" `shouldRespondWith` "Hello World!" {matchStatus = 200}

    describe "POST /proj" $ do
      it "responds with a redirect" $
        postHtmlForm "/proj" [("projName", "Free Bird!")] `shouldRespondWith` 302 {matchHeaders = ["Location" <:> "/"]}
      it "creates a new project" $
        get "/proj/Free-Bird" `shouldRespondWith` 200
