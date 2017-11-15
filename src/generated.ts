export type State = { fruits: string[] };
export type Utils = {
  initialState: { fruits: string[] },
  processAction: (a: { fruits: string[] }) => (
    a:
      | { type: "addFruit", value: { fruit: string } }
      | { type: "removeFruit", value: { fruit: string } }
  ) => { fruits: string[] }
};
export type Action =
  | { type: "addFruit", value: { fruit: string } }
  | { type: "removeFruit", value: { fruit: string } };
