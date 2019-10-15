# Decision-Making-Network
The code reproduces the model in Wong &amp; Wang 2006 to explain the ramping activity appeared in the monkey's lateral intraparietal (LIP) cortex during decision making task.

The code is implemented in [R](https://www.r-project.org/), but can be changed into matlab or python easily.

# Requirement
R (3.6.1)

# Model
The model is reduced from a more biological plausible yet more complexed model (Wang 2002). The reduced model only contains 2 neurons, reprensenting two neural population with different preferences. The model exbits both properties in persistent activity and decision making in the brain. The structure is depicted in the following diagram (from the paper):

<img src="model structure.png">

# Model Parameter
The model parameters follow the parameters in the appendix of the paper, as below:

<img src="model appendix.png">

# Sample output
Below shows the results from 3 seconds simulation of the model. From bottom to below: firing rates, state variables, total input, recurrent input and feedforward input, of the two neurons. Blue represents right preferring neuron, and red represents the left preferring neuron.

<img src="sample output.png">

# Reference
If you find my code useful, please cite the original paper:

    @article{wong2006recurrent,
      title={A recurrent network mechanism of time integration in perceptual decisions},
      author={Wong, Kong-Fatt and Wang, Xiao-Jing},
      journal={Journal of Neuroscience},
      volume={26},
      number={4},
      pages={1314--1328},
      year={2006},
      publisher={Soc Neuroscience}
    }
