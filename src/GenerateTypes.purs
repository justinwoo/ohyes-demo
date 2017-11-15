module GenerateTypes where

import Prelude

import Control.Monad.Aff (launchAff_)
import Control.Monad.Eff (Eff)
import Data.Array (intercalate)
import Main (State, Utils, Action)
import Node.Encoding (Encoding(..))
import Node.FS.Aff (FS, writeTextFile)
import OhYes (generateTS)
import Text.Prettier (defaultOptions, format)
import Type.Prelude (Proxy(..))

main :: forall e. Eff (fs :: FS | e) Unit
main = launchAff_ do
  writeTextFile UTF8 "./src/generated.ts" values
  where
    values = format defaultOptions $ intercalate "\n"
      [ generateTS "State" (Proxy :: Proxy State)
      , generateTS "Utils" (Proxy :: Proxy Utils)
      , generateTS "Action" (Proxy :: Proxy Action)
      ]
