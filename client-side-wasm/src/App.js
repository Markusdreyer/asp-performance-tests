import "./App.css";
import { useEffect } from "react";
import { harrySally, schurNumbers, aeFire } from "./asp-examples.js";
import * as clingo from "clingo-wasm";

function App() {
  let totalTime = {
    total: 0,
    solve: 0,
    model: 0,
    cpu: 0,
  };

  const accumulator = (time) => {
    totalTime.total = totalTime.total + time.Total;
    totalTime.solve = totalTime.solve + time.Solve;
    totalTime.model = totalTime.model + time.Model;
    totalTime.cpu = totalTime.cpu + time.CPU;
  };

  const resetTotalTime = () => {
    totalTime = {
      total: 0,
      solve: 0,
      model: 0,
      cpu: 0,
    };
  };

  const clingoWasmPerfTest = async (program) => {
    await clingo.init(
      "https://cdn.jsdelivr.net/npm/clingo-wasm@0.0.10/dist/clingo.wasm"
    );
    const iterations = 100;
    console.log(`Starting performance test. Running ${iterations} iterations.`);
    for (let i = 0; i < iterations; i++) {
      console.log(
        `${i} iterations completed. ${iterations - i} iterations left.`
      );
      await clingo.run(program).then((res) => {
        console.log(res);
        if (res) {
          if (res.Result === "ERROR") {
            console.log("MODEL ERROR");
          } else {
            accumulator(res.Time);
          }
        } else {
          console.log("No response!");
        }
      });
    }
    console.log("Total time: ", totalTime);
    totalTime = resetTotalTime();
  };

  console.log(clingoWasmPerfTest(aeFire));

  return (
    <div className="App">
      <p>Hei</p>
    </div>
  );
}

export default App;
