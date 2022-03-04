import clingo
import json

total_times = {
    "cpu": 0,
    "solve": 0,
    "total": 0
}

for i in range(0,100):
    prg = clingo.Control()
    prg.load("ae-fire.lp")
    prg.ground([("base", [])])
    prg.solve()
    model_times = prg.statistics["summary"]["times"]
    total_times["total"] += model_times["total"]
    total_times["cpu"] += model_times["cpu"]
    total_times["solve"] += model_times["solve"]
 
print(total_times)
#print(json.dumps(prg.statistics["summary"]["times"], sort_keys=True, indent=4, separators=(',', ': ')))

