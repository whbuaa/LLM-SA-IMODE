# LLM-SA-IMODE

## Overview

LLM-SA-IMODE (Large Language Model-based Self-Adaptive Improved Multi-Operator Differential Evolution) is an advanced evolutionary optimization algorithm implemented in MATLAB. This algorithm combines differential evolution with machine learning techniques to solve complex optimization problems.

## Features

- **Multi-Operator Differential Evolution**: Implements multiple mutation operators for enhanced exploration
- **Machine Learning Integration**: Uses K-Nearest Neighbors (KNN) classifier for intelligent solution selection
- **Self-Adaptive Parameters**: Automatically adjusts control parameters during optimization
- **Archive-based Search**: Maintains an archive of solutions for improved diversity
- **Eigencoordinate System**: Utilizes eigenspace transformations for better convergence

## Requirements

- MATLAB R2018a or higher
- Python 3.x with scikit-learn (for KNN classifier)
- MATLAB Python integration configured (use `pyenv` to verify Python is accessible)
- PlatEMO framework integration

## Project Structure

```
LLM-SA-IMODE/
├── LLM_SA_IMODE.m      # Main algorithm implementation
├── ALGORITHM.m          # Base algorithm class
├── refine_evo.m         # Refinement evolution function
├── platemo.m            # PlatEMO platform interface
├── run.m                # Batch execution script
└── Problems/            # Test problem definitions
    ├── F1-F7/           # CEC2013 benchmark functions (F1-F7)
    ├── YLL/             # Additional test problems
    ├── PROBLEM.m        # Problem base class
    ├── SOLUTION.m       # Solution representation class
    └── UserProblem.m    # User-defined problem template
```

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/whbuaa/LLM-SA-IMODE.git
   ```

2. Ensure MATLAB is installed with proper Python integration

3. Install required Python packages:
   ```bash
   pip install scikit-learn numpy
   ```

4. Add the project directory to your MATLAB path:
   ```matlab
   addpath(genpath('path/to/LLM-SA-IMODE'))
   ```

## Usage

### Quick Start

Run a single optimization task:

```matlab
% Run LLM-SA-IMODE on problem F1 with 50 dimensions
[Dec, Obj, Con] = platemo('algorithm', @LLM_SA_IMODE, ...
                          'problem', @F1, ...
                          'N', 5, ...           % Population size
                          'M', 1, ...           % Number of objectives
                          'D', 50, ...          % Problem dimension
                          'maxFE', 1000);       % Maximum function evaluations
```

### Batch Experiments

To run comprehensive experiments across multiple problems and dimensions:

1. Open and edit `run.m` to configure:
   - `run_N`: Number of independent runs (default: 20)
   - `algorithms_name`: Algorithm(s) to test
   - `problem_name`: Test problems (F1-F7)
   - `D_N`: Problem dimensions to test

2. **Important**: Update the save path in `run.m` (line 34) to your local directory:
   ```matlab
   cd 'path/to/your/LLM-SA-IMODE'
   ```
   
   The default path in the file is: `'C:\Users\chengzi\Desktop\LLM-SA-IMODE'`

3. Run the script:
   ```matlab
   run
   ```

### Algorithm Parameters

The algorithm accepts two main parameters:

- `minN` (default: 4): Minimum population size
- `aRate` (default: 5): Ratio of archive size to population size

Example with custom parameters:
```matlab
% Using custom aRate value (2.6 instead of default 5)
platemo('algorithm', {@LLM_SA_IMODE, 4, 2.6}, ...
        'problem', @F1, ...
        'N', 10, 'D', 100, 'maxFE', 5000)
```

## Test Problems

The repository includes benchmark functions from CEC2013:

- **F1**: Shifted Elliptic Function
- **F2-F7**: Additional large-scale global optimization benchmarks

Each problem supports customizable dimensions (default: 30) and search ranges.

## Output

After running experiments, the following files are generated:

- `*_sign_res.mat`: Raw results for statistical significance testing
- `*_med_res.mat`: Median and IQR (Interquartile Range) values
- `*_avg_res.mat`: Mean and standard deviation values
- `*_avg_time.mat`: Average execution time and standard deviation

Results are organized by dimension, with each problem-algorithm combination storing median and IQR statistics.

## Algorithm Overview

### Key Components

1. **Initialization**: Random population generation with training data collection
2. **Population Reduction**: Adaptive population sizing based on function evaluations
3. **Eigencoordinate System**: PCA-based coordinate transformation
4. **Multi-Operator Mutation**: Five different mutation strategies
5. **ML-based Selection**: KNN classifier predicts offspring quality
6. **Parameter Adaptation**: Self-adaptive CR and F parameters

### Citation

This work is based on the improved multi-operator differential evolution algorithm. When using this code, please cite:

```
K. M. Sallam, S. M. Elsayed, R. K. Chakrabortty, and M. J. Ryan,
"Improved multi-operator differential evolution algorithm for solving unconstrained problems,"
Proceedings of the IEEE Congress on Evolutionary Computation, 2020.
```

### PlatEMO Framework

This implementation uses the PlatEMO platform. Please also cite:

```
Ye Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin,
"PlatEMO: A MATLAB platform for evolutionary multi-objective optimization [educational forum],"
IEEE Computational Intelligence Magazine, 2017, 12(4): 73-87.
```

## License

Copyright (c) 2021 BIMK Group. You are free to use this code for research purposes. All publications using this code should acknowledge the use of PlatEMO and cite the relevant papers.

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## Contact

For questions or collaborations, please open an issue on GitHub.
