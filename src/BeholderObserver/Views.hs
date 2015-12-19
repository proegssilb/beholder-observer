{-# LANGUAGE OverloadedStrings #-}
module BeholderObserver.Views
    (
    renderProject,
    renderProjectList
    ) where
import           BeholderObserver.Data
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as HA
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
