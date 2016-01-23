{-# LANGUAGE OverloadedStrings #-}
module AcidStateSpec where

import           Control.Exception (bracket)
import           Test.Hspec
import           Test.QuickCheck
import           Test.QuickCheck.Monadic (assert, monadicIO, run)
import           Test.Hspec.Wai
import           Test.Hspec.QuickCheck
import           System.Directory
import           Data.Acid
import           Data.Acid.Memory
import           Data.Map as M (empty)
import qualified Web.Scotty as S
import           BeholderObserver.Dispatch
import           BeholderObserver.AcidState
import           BeholderObserver.Data
import           System.Random
import           TestUtil

openState :: IO AcidStateDataLoader
openState = openMemoryState (KeyVal M.empty)

closeState :: AcidStateDataLoader -> IO ()
closeState = closeAcidState

withState :: (AcidStateDataLoader -> IO ()) -> IO ()
withState = bracket openState closeState

-- Can't figure out how to integrate IO Properties with QuickCheck.
prop_StoreReadProj :: Project -> Property
prop_StoreReadProj prj = monadicIO $ do
  asdl <- run openState
  run $ addProject asdl prj
  projs <- run $ listProjects asdl
  assert $ prj `elem` projs
  run $ closeState asdl

spec :: Spec
spec = describe "AcidStateDataLoader" $ do
  it "begins empty" $ withState $ \as -> do
    projs <- listProjects as
    projs `shouldSatisfy` null
  it "stores projects" $ withState $ \as -> do
    let proj = Project "Project Name" "Project-Name" []
    addProject as proj
    projs <- listProjects as
    proj `shouldSatisfy` (`elem` projs)
  it "stores arbitrary projects" $ property prop_StoreReadProj
