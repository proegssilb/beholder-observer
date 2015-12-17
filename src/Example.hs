{-# LANGUAGE OverloadedStrings #-}
module Example (runApp, app) where

import           Data.Aeson (Value(..), object, (.=))
import           Network.Wai (Application)
import           BeholderObserver.Constant
import           BeholderObserver.Data
import           Data.Foldable (asum)
import qualified Text.Blaze.Html5 as H
import qualified Web.Scotty as S
import qualified Text.Blaze.Html.Renderer.Text as TR

renderProjectListItem :: Project -> H.Html
renderProjectListItem = H.li . H.toHtml . projName

renderProject :: Project -> H.Html
renderProject = H.html . H.body . H.h1 . H.toHtml . projName

site :: ConstantDataLoader -> S.ScottyM ()
site dl = do
  S.get "/" $
    S.html . TR.renderHtml $
      H.html $
        H.body $ do
          H.h1 "What are you working on today?"
          H.ul . mapM_ renderProjectListItem . listProjects $ dl
  S.get "/test" $ S.text "Hello World!"
  S.get "/proj/:projId" $ do
    pid <- S.param "projId"
    S.html . TR.renderHtml $ renderProject . head . filter (\p -> projId p == pid) . listProjects $ dl

app :: IO Application
app = S.scottyApp $ site ConstantDataLoader

runApp :: IO ()
runApp = S.scotty 8080 $ site ConstantDataLoader