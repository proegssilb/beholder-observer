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
renderProject = H.html . H.body . H.h1 . H.toHtml . projName

renderProjectList :: DataLoader d => d -> H.Html
renderProjectList dl = H.html $ H.body $ do
  H.h1 "What are you working on today?"
  H.ul . mapM_ drawItem . listProjects $ dl
  where drawItem p = H.li . (H.a  H.! url p ). H.toHtml . projName $ p
        url p = HA.href . T.pack $ "/proj/" ++ projId p

site :: ConstantDataLoader -> S.ScottyM ()
site dl = do
  S.get "/" $
    S.html . TR.renderHtml . renderProjectList $ dl
  S.get "/test" $ S.text "Hello World!"
  S.get "/proj/:projId" $ do
    pid <- S.param "projId"
    S.html . TR.renderHtml $ renderProject . head . filter (\p -> projId p == pid) . listProjects $ dl

app :: IO Application
app = S.scottyApp $ site ConstantDataLoader

runApp :: IO ()
runApp = S.scotty 8080 $ site ConstantDataLoader
