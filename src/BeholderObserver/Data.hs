{-# LANGUAGE OverloadedStrings #-}

module BeholderObserver.Data (
  Project(..),  DocSet(..),  Doc(..), DataLoader,
  listProjects,  readDocs,  readDocSets,  findDoc
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
} | HtmlDoc {
  docTitle :: Text,
  docId :: Text,
  docHtml :: Html
}

class DataLoader dl where
  listProjects :: dl -> [Project]
  readDocSets :: dl -> Project -> [DocSet]
  readDocs :: dl -> DocSet -> [Doc]
  findDoc :: dl -> Text -> [Doc]
