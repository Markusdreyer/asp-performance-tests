const http = require("http");
const fs = require("fs");
const clingoWasm = require("clingo-wasm");

const hostname = "127.0.0.1";
const port = 3000;
const program = fs.readFileSync("../ae-fire.lp", "utf8");
let totalTime = {
  total: 0,
  solve: 0,
  model: 0,
  cpu: 0,
};

const server = http.createServer((req, res) => {
  clingoWasmPerfTest(program);
  res.statusCode = 200;
  res.setHeader("Content-Type", "text/plain");
  res.end("Hello World");
});

server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});

const accumulator = (time) => {
  totalTime.total = totalTime.total + time.Total;
  totalTime.solve = totalTime.solve + time.Solve;
  totalTime.model = totalTime.model + time.Model;
  totalTime.cpu = totalTime.cpu + time.CPU;
};

const resetTotalTime = () => {
  return {
    total: 0,
    solve: 0,
    model: 0,
    cpu: 0,
  };
};

const clingoWasmPerfTest = async (file) => {
  const iterations = 100;
  console.log(`Starting performance test. Running ${iterations} iterations.`);
  for (let i = 0; i < iterations; i++) {
    console.log(
      `${i} iterations completed. ${iterations - i} iterations left.`
    );
    await clingoWasm.run(file).then((res) => {
      accumulator(res.Time);
    });
  }
  console.log("Total time: ", totalTime);
  totalTime = resetTotalTime();
};
