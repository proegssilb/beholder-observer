{-# LANGUAGE OverloadedStrings #-}

module BeholderObserver.Controller (
  addNewProject
) where

  import Data.Text as T
  import BeholderObserver.Data

  addNewProject :: DataLoader dldr => dldr -> Text -> IO Project
  addNewProject dl projectName =
    let projectId = getProjectIdFromName projectName
        project = Project projectId projectName []
    in do
      addProject dl project
      return project

  punct = '"' : "',./;'[]\\`-=~!@#$%^&*()_+{}|:<>?"

  getProjectIdFromName :: T.Text -> T.Text
  getProjectIdFromName = T.replace " " "-" . stripChars

  stripChars :: T.Text -> T.Text
  stripChars "" = ""
  stripChars txt =
    let c = T.head txt
        cs = T.tail txt
    in if c `elem` punct then stripChars cs else T.cons c . stripChars $ cs
