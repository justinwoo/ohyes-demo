module Main where

import Prelude

import Data.Array (filter, snoc)
import Data.Variant (Variant, match)
import OhYes (class HasTSRep)

newtype Fruit = Fruit String
derive newtype instance eqFruit :: Eq Fruit
derive newtype instance hasTSRepFruit :: HasTSRep Fruit

type State =
  { fruits :: Array Fruit
  }

type Utils =
  { processAction :: State -> Action -> State
  , initialState :: State
  }

utils :: Utils
utils =
  { processAction
  , initialState
  }
  where
    processAction :: State -> Action -> State
    processAction state = match
      { addFruit: \value -> state { fruits = snoc state.fruits value.fruit }
      , removeFruit: \value -> state { fruits = filter ((/=) value.fruit) state.fruits }
      }
    initialState = { fruits: [] }


type Action = Variant
  ( addFruit :: { fruit :: Fruit }
  , removeFruit :: { fruit :: Fruit }
  )
