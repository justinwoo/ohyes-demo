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