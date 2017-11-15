# OhYes Demo

Demo using a setup you probably don't want, but shows how the [OhYes](https://github.com/justinwoo/purescript-ohyes) library can be used.

## The Gist

### Main.purs

Main.purs has some types and a "utils" record of stuff I'm going to use and writes them to src/main.js:

```hs
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
```

### GenerateTypes.purs

GenerateTypes.purs generates types and writes them to src/generated.ts:

```hs
main :: forall e. Eff (fs :: FS | e) Unit
main = launchAff_ do
  writeTextFile UTF8 "./src/generated.ts" values
  where
    values = format defaultOptions $ intercalate "\n"
      [ generateTS "State" (Proxy :: Proxy State)
      , generateTS "Utils" (Proxy :: Proxy Utils)
      , generateTS "Action" (Proxy :: Proxy Action)
      ]
```

### index.ts

This is my TypeScript program that pulls in utils and uses it with the Utils type defined in Main.

```ts
import {State, Utils, Action} from './generated';
import * as Main from './main'

const utils = Main.utils as Utils

const initialState = utils.initialState
const nextState1 = utils.processAction(
  initialState
)({
  type: "addFruit",
  value: {
    fruit: "Apple"
  }
})
const nextState2 = utils.processAction(
  nextState1
)({
  type: "addFruit",
  value: {
    fruit: "Kiwi"
  }
})
const nextState3 = utils.processAction(
  nextState2
)({
  type: "removeFruit",
  value: {
    fruit: "Kiwi"
  }
})

console.log('initialState', initialState)
console.log('  nextState1', nextState1)
console.log('  nextState2', nextState2)
console.log('  nextState3', nextState3)
```

The result of adding an apple, adding a kiwi, and removing a kiwi is as follows:

```
initialState { fruits: [] }
  nextState1 { fruits: [ 'Apple' ] }
  nextState2 { fruits: [ 'Apple', 'Kiwi' ] }
  nextState3 { fruits: [ 'Apple' ] }
```

Hopefully this gives you some ideas on how you want to use this library for your own uses.
