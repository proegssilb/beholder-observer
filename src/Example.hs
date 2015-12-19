{-# LANGUAGE OverloadedStrings #-}
module Example (runApp, app) where

import           Data.Aeson (Value(..), object, (.=))
import           Network.Wai (Application)
import           BeholderObserver.Constant
import           BeholderObserver.Data
import           Data.Foldable (asum)
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as HA
import qualified Web.Scotty as S
import qualified Text.Blaze.Html.Renderer.Text as TR
import qualified Data.Text as T

renderProject :: Project -> H.Html
renderProject p = H.html . H.body $ do
  H.h1 . H.toHtml . projName $ p
  H.ul . mapM_ drawItem . projDocSets $ p
  where drawItem = H.li . H.toHtml . dsName

renderProjectList :: [Project] -> H.Html
renderProjectList pl = H.html $ H.body $ do
  H.h1 "What are you working on today?"
  H.ul . mapM_ drawItem $ pl
  where drawItem p = H.li . (H.a  H.! url p ). H.toHtml . projName $ p
        url = HA.href . H.toValue . T.append "/proj/" . projId

site :: DataLoader dl => dl -> S.ScottyM ()
site dl = do
  S.get "/" $
    S.html . TR.renderHtml . renderProjectList . listProjects $ dl
  S.get "/test" $ S.text "Hello World!"
  S.get "/proj/:projId" $ do
    pid <- S.param "projId"
    S.html . TR.renderHtml $ renderProject . head . filter (\p -> projId p == pid) . listProjects $ dl

app :: IO Application
app = S.scottyApp $ site ConstantDataLoader

runApp :: IO ()
runApp = S.scotty 8080 $ site ConstantDataLoader
