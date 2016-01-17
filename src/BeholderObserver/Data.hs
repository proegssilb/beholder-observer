{-# LANGUAGE OverloadedStrings #-}

module BeholderObserver.Data (
  Project(..),  DocSet(..),  Doc(..), DataLoader,
  listProjects,  readDocs,  readDocSets,  findDoc,
  load, readOnly, addProject
) where

import Data.Text
import Data.ByteString
import Text.Blaze.Html


data Project = Project {
  projId :: Text,
  projName :: Text,
  projDocSets :: [DocSet]
}

data DocSet = DocSet {
  dsId :: Text,
  dsName :: Text,
  dsDocs :: [Doc]
}

data Doc = TextDoc {
  docTitle :: Text,
  docId :: Text,
  docText :: Text
--} | HtmlDoc {
--  docTitle :: Text,
--  docId :: Text,
--  docHtml :: Html
}

class DataLoader dl where
  load :: IO dl
  listProjects :: dl -> IO [Project]
  readDocSets :: dl -> Project -> IO [DocSet]
  readDocs :: dl -> DocSet -> IO [Doc]
  findDoc :: dl -> Text -> IO [Doc]
  readOnly :: dl -> IO Bool
  addProject :: dl -> Project -> IO dl
