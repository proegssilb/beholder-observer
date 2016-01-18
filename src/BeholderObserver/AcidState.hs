{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE DeriveDataTypeable   #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE TypeFamilies         #-}
{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FlexibleInstances    #-}

module BeholderObserver.AcidState (
  AcidStateDataLoader(..), KeyVal(..)
)

where
  import BeholderObserver.Data
  import Data.Acid
  import Data.Text
  import Data.SafeCopy
  import Data.Typeable
  import Control.Monad.Reader
  import Control.Monad.State
  import qualified Data.Map.Strict as Map

  ------------------------------------------------------
  -- The Haskell structure that we want to encapsulate

  type Key = Text
  type Value = Project

  data KeyVal = KeyVal !(Map.Map Key Value)
      deriving (Typeable)

  $(deriveSafeCopy 0 'base ''Doc)
  $(deriveSafeCopy 0 'base ''DocSet)
  $(deriveSafeCopy 0 'base ''Project)
  $(deriveSafeCopy 0 'base ''KeyVal)

  ------------------------------------------------------
  -- The transaction we will execute over the state.

  insertKey :: Key -> Value -> Update KeyVal ()
  insertKey key value
      = do KeyVal m <- get
           put (KeyVal (Map.insert key value m))

  lookupKey :: Key -> Query KeyVal (Maybe Value)
  lookupKey key
      = do KeyVal m <- ask
           return (Map.lookup key m)

  listValues :: Query KeyVal [Value]
  listValues = do
    KeyVal m <- ask
    return $ Map.elems m


  $(makeAcidic ''KeyVal ['insertKey, 'lookupKey, 'listValues])

  ------------------------------------------------------
  -- DataLoader stuff

  type AcidStateDataLoader = AcidState KeyVal

  instance DataLoader AcidStateDataLoader where
    load = openLocalState  (KeyVal Map.empty)
    listProjects asdl = query asdl ListValues
    readDocSets asdl = return . projDocSets
    readDocs asdl = return . dsDocs
    findDoc asdl _ = return []
    readOnly _ = return False
    addProject asdl proj = do
      update asdl (InsertKey (projName proj) proj)
      return asdl
