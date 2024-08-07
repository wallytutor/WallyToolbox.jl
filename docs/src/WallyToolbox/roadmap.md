# Roadmap

- Transform training or `RadCalNet.jl` into a simple notebook, so that most of module code does not need to be continuously maintained; move ANN interface to `WallyToolbox.jl`. Move tests currently in documentation to their own test set to make documentation cleaner.

- Integrate Kramers model validation to the transport module with major code clean-up and standardization; move suitable parts to the tests.

- Implement third-generation Calphad formalist; a good starting point seems to be the paper by ([[@Deffrennes2020]]) as a discussion of different forms of representation is provided.

- Evaluation of equivalent fuels for simplified combustion simulations has come to my attention because most of my current activities might profit from that. Write a general approach for reducing a *CHONS* fuel into an equivalent single species with same molecular mass as the original fuel, extending what already exists for HFO.

