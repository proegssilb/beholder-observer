{-# LANGUAGE OverloadedStrings #-}
module AcidStateSpec where

import           Control.Exception (bracket)
import           Test.Hspec
import           Test.QuickCheck
import           Test.QuickCheck.Monadic (assert, monadicIO)
import           Test.Hspec.Wai
import           Test.Hspec.QuickCheck
import           System.Directory
import           Data.Acid
import           Data.Map as M (empty)
import qualified Web.Scotty as S
import           BeholderObserver.Dispatch
import           BeholderObserver.AcidState
import           BeholderObserver.Data

openState :: IO AcidStateDataLoader
openState = openLocalStateFrom "testState" (KeyVal M.empty)

closeState :: AcidStateDataLoader -> IO ()
closeState asdl = do
  closeAcidState asdl
  removeDirectoryRecursive "testState"

withState :: (AcidStateDataLoader -> IO ()) -> IO ()
withState = bracket openState closeState

{-
-- Can't figure out how to integrate IO Properties with QuickCheck.
prop_StoreReadProj :: AcidStateDataLoader -> Project -> Property
prop_StoreReadProj asdl prj = monadicIO $ do
  addProject asdl prj
  projs <- listProjects asdl
  assert $ prj `elem` projs
-}

spec :: Spec
spec = describe "AcidStateDataLoader" $ do
  it "begins empty" $ withState $ \as -> do
    projs <- runIO $ listProjects as
    projs `shouldSatisfy` null
  {-it "stores projects" $ withState $ \as -> do
    proj <- return Project "Project Name" "Project-Name" []
    runIO $ addProject as proj
    projs <- runIO $ listProjects as
    projs `shouldContain` proj
-}
