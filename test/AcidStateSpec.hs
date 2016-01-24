{-# LANGUAGE OverloadedStrings #-}
module AcidStateSpec where

import           Control.Exception (bracket)
import           Control.Monad (forM_)
import           Test.Hspec
import           Test.QuickCheck
import           Test.QuickCheck.Monadic (assert, monadicIO, run, pre)
import           Test.Hspec.Wai
import           Test.Hspec.QuickCheck
import           Data.Acid
import           Data.Acid.Memory
import           Data.Map as M (empty)
import           Data.List (nubBy, length)
import           Data.Function (on)
import qualified Web.Scotty as S
import           BeholderObserver.Dispatch
import           BeholderObserver.AcidState
import           BeholderObserver.Data
import           System.Random
import           TestUtil
import qualified Control.Monad.Parallel as MP

openState :: IO AcidStateDataLoader
openState = openMemoryState (KeyVal M.empty)

closeState :: AcidStateDataLoader -> IO ()
closeState = closeAcidState

withState :: (AcidStateDataLoader -> IO ()) -> IO ()
withState = bracket openState closeState

prop_StoreReadProj :: Project -> Property
prop_StoreReadProj prj = monadicIO $ do
  asdl <- run openState
  run $ addProject asdl prj
  projs <- run $ listProjects asdl
  assert $ prj `elem` projs
  run $ closeState asdl

prop_CanStoreManyProjects :: [Project] -> Property
prop_CanStoreManyProjects prjs = monadicIO $ do
  let inProjs = nubBy (on (==) projName) prjs
  --Too much of a performance hit to check that we kept data...
  --pre $ length inProjs > length prjs * 2 `div` 3
  asdl <- run openState
  run $ MP.forM_ inProjs $ addProject asdl
  projs <- run $ listProjects asdl
  forM_ inProjs (\p -> assert $ p `elem` projs)

spec :: Spec
spec = describe "AcidStateDataLoader" $ parallel $ do
  it "begins empty" $ withState $ \as -> do
    projs <- listProjects as
    projs `shouldSatisfy` null
  it "stores projects" $ withState $ \as -> do
    let proj = Project "Project Name" "Project-Name" []
    addProject as proj
    projs <- listProjects as
    proj `shouldSatisfy` (`elem` projs)
  it "stores arbitrary projects" $ property prop_StoreReadProj
  it "can store many projects" $ property prop_CanStoreManyProjects
