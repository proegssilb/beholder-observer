{-# LANGUAGE OverloadedStrings #-}
module BeholderObserver.Dispatch (site) where

import           Data.Aeson (Value(..), object, (.=))
import           Network.Wai (Application)
import           BeholderObserver.AcidState
import           BeholderObserver.Data
import           BeholderObserver.Views
import           BeholderObserver.Controller
import           Data.Foldable (asum)
import           Control.Monad.IO.Class
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as HA
import qualified Web.Scotty as S
import qualified Text.Blaze.Html.Renderer.Text as TR
import qualified Data.Text as T

site :: DataLoader dl => dl -> S.ScottyM ()
site dl = do
  S.get "/" $ do
    projects <- liftIO . listProjects $ dl
    S.html . TR.renderHtml . renderProjectList $ projects
  S.get "/test" $ S.text "Hello World!"
  S.get "/proj/:projId" $ do
    pid <- S.param "projId"
    projects <- liftIO . listProjects $ dl
    S.html . TR.renderHtml . renderProject . head . filter (\p -> projId p == pid) $ projects
  S.post "/proj" $ do
    projectName <- S.param "projName"
    project <- liftIO $ addNewProject dl projectName
    S.redirect "/"
