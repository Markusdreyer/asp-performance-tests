# Performance results

## Specs

MacBook Pro (15-inch, 2018)
CPU: 2,2 GHz 6-Core Intel Core i7
RAM: 16 GB 2400 MHz DDR4
GPU: Radeon Pro 555X 4 GB

## Harry and sally program

The Harry and Sally program is one of the most simple programs. The tests included grounding and solving of the program 10,000 times. The resulting times was fetched from the program itself, and not measured externally.

| Environment | Avg. Runtime |
| ----------- | ------------ |
| Node        | 0.00013      |
| Python      | 0.00007      |

## Schur numbers program

The Schur number program is somewhat more complex. A set X of numbers is called sum-free if the sum of two elements of X never belongs to X. For instance, the set {5, . . . , 9} is sum-free; the set {4, . . . , 9} is not (4+4 = 8, 4 + 5 = 9). Can we partition the set {1, . . . , n} into two sum-free subsets? This is possible if n = 4: both {1, 4} and {2, 3} are sum-free. But if n = 5 then such a partition does not exist.

The tests included grounding and solving of the program 10,000 times. The resulting times was fetched from the program itself, and not measured externally.

| Environment | Avg. Runtime |
| ----------- | ------------ |
| Node        | 0.052        |
| Python      | 0.0047       |

## Tool concept examples

The following tests were run with the control file along with actions and taxonomy for a given scenario. The number of iterations for these tests were reduced to 100.
| Environment | Avg. Runtime |
| ----------- | ------------ |
| Node | 0.7646 |
| Python | 0.3511 |

## Running in VM

## ae-fire

100 iterations of control and scenario.

### Specs

| RAM | CPUs | Capacity |
| --- | ---- | -------- |
| 6GB | 4    | 100 %    |

#### Results

| Environment | Avg. Runtime |
| ----------- | ------------ |
| Python      | 0.32         |
| Node        | 0.88         |
| Client      | 1.27         |

### Specs

| RAM | CPUs | Capacity |
| --- | ---- | -------- |
| 2GB | 1    | 100 %    |

#### Results

| Environment | Avg. Runtime |
| ----------- | ------------ |
| Python      | 0.37         |
| Node        | 1.08         |
| Client      | 1.38         |

### Specs

| RAM | CPUs | Capacity |
| --- | ---- | -------- |
| 1GB | 1    | 50 %     |

#### Results

| Environment | Avg. Runtime |
| ----------- | ------------ |
| Python      | 0.86         |
| Node        | 2.41         |
| Client      | 3.76         |
