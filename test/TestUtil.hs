{-# LANGUAGE OverloadedStrings #-}

module TestUtil where

  import BeholderObserver.Data
  import Test.QuickCheck
  import Data.Text as T

  instance Arbitrary Project where
    arbitrary = Project <$> arbitrary <*> arbitrary <*> arbitrary

  instance Arbitrary DocSet where
    arbitrary = DocSet <$> arbitrary <*> arbitrary <*> arbitrary

  instance Arbitrary Doc where
    arbitrary = TextDoc <$> arbitrary <*> arbitrary <*> arbitrary

  instance Arbitrary Text where
    arbitrary = T.pack <$> arbitrary
