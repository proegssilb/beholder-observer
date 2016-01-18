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
  renderItemList (drawItem p) . projDocSets $ p
  renderNewItemForm "dsName" (T.append "/proj/" $ projId p) "New DocSet"
  where drawItem p ds = (dsName ds, dsUrl p ds)
        dsUrl p ds = T.intercalate "/" ["/proj/", projId p, dsId ds]

renderProjectList :: [Project] -> H.Html
renderProjectList pl = H.html $ H.body $ do
  H.h1 "What are you working on today?"
  renderItemList renderProj pl
  renderNewItemForm "projName" "/proj" "New Project"
  where renderProj p = (projName p, T.append "/proj/" $ projId p)

renderItemList :: (a -> (T.Text, T.Text)) -> [a] -> H.Html
renderItemList renderer = H.ul . mapM_ (drawItem . renderer)
  where drawItem (ln, lu) = H.li $ H.a H.! HA.href (H.toValue lu) $ H.toHtml ln
        drawItem :: (T.Text, T.Text) -> H.Html

renderNewItemForm :: T.Text -> T.Text -> T.Text -> H.Html
renderNewItemForm argName actionStr btnText =
  H.form H.! HA.method "post" H.! HA.action (H.toValue actionStr) $ do
    H.input H.! HA.type_ "text" H.! HA.name (H.toValue argName)
    H.input H.! HA.type_ "submit" H.! HA.value (H.toValue btnText)
